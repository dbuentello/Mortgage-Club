var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var FlashHandler = require("mixins/FlashHandler");
var ValidationObject = require("mixins/ValidationMixins");

var AddressField = require("components/form/NewAddressField");
var SelectField = require("components/form/NewSelectField");
var TextField = require("components/form/NewTextField");
var BooleanRadio = require("components/form/NewBooleanRadio");

var fields = {
  address: {label: 'Property Address', name: 'address', helpText: "The full address of the subject property for which you are applying for a loan.", error: "addressError"},
  loanPurpose: {label: "Purpose of Loan", name: "purpose", helpText: "The purpose for taking out the loan in terms of how funds will be used.", error: "loanError"},
  propertyPurpose: {label: "Property Will Be", name: "usage", helpText: "The primary purpose of acquiring the subject property.", error: "propertyError"},
  purchasePrice: {label: "Purchase Price", name: "purchase_price", helpText: "How much are you paying for the subject property?", error: "purchaseError"},
  originalPurchasePrice: {label: "Original Purchase Price", name: "original_purchase_price", helpText: "How much did you pay for the subject property?", error: "originalPurchasePriceError"},
  originalPurchaseYear: {label: "Purchase Year", name: "original_purchase_year", helpText: "The year in which you bought your home.", error: "originalPurchaseYearError"},
  yearBuilt: {label: "Year Built", name: "year_built", error: "yearBuiltError"}
};

var loanPurposes = [
  {value: "purchase", name: "Purchase"},
  {value: "refinance", name: "Refinance"}
];

var propertyPurposes = [
  {value: "primary_residence", name: "Primary Residence"},
  {value: "vacation_home", name: "Vacation Home"},
  {value: "rental_property", name: "Rental Property"}
];

var FormProperty = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin, FlashHandler],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state.isValid = true;
    return state;
  },

  componentDidUpdate: function(){
    if(!this.state.isValid)
      this.scrollTopError();
  },

  onChange: function(change) {
    var address = change.address;
    if (address) {
      this.setState({property: null});
      if (address.city && address.zip && address.state) {
        this.searchProperty(address);
      }
    }
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  searchProperty: function(address) {
    var result_obj = this.state;
    $.ajax({
      url: '/properties/search',
      data: {
        address: [address.street_address, address.street_address2].join(' '),
        citystatezip: [address.city, address.state, address.zip].join(' ')
      },
      dataType: 'json',
      context: this,
      success: function(response) {
        if (response.message == 'cannot find') {
          return;
        }

        var marketPrice = this.getValue(response, 'zestimate.amount.__content__');
        var monthlyTax = this.getValue(response, 'monthlyTax');
        var monthlyInsurance = this.getValue(response, 'monthlyInsurance');
        var yearBuilt = this.getValue(response, 'yearBuilt');
        var lastSoldDate = this.getValue(response, 'lastSoldDate');
        var lastSoldPrice = this.getValue(response, 'lastSoldPrice.__content__');
        var purchaseYear = (lastSoldDate ? new Date(Date.parse(lastSoldDate)).getFullYear() : null);
        var zillowImageUrl = this.getValue(response, 'zillowImageUrl');

        var state = {} ;
        state.marketPrice = this.formatCurrency(marketPrice);
        state.estimatedPropertyTax = monthlyTax;
        state.estimatedHazardInsurance = monthlyInsurance;
        state.yearBuilt = yearBuilt;
        state.zillowImageUrl = zillowImageUrl
        state[fields.originalPurchasePrice.name] = this.formatCurrency(lastSoldPrice);
        state[fields.originalPurchaseYear.name] = purchaseYear;
        this.setState(state);
      }
    });
  },

  render: function() {
    return (
      <div className="col-sm-9 col-xs-12 account-content">
        <form className="form-horizontal">
          <div className="form-group">
            <div className="col-md-12">
              <AddressField label={fields.address.label}
                activateRequiredField={this.state[fields.address.error]}
                address={this.state[fields.address.name]}
                keyName={fields.address.name}
                editable={true}
                helpText={fields.address.helpText}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.address)}
                placeholder=""/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-md-6">
              <SelectField
                requiredMessage="This field is required"
                activateRequiredField={this.state[fields.propertyPurpose.error]}
                label={fields.propertyPurpose.label}
                keyName={fields.propertyPurpose.name}
                value={this.state[fields.propertyPurpose.name]}
                options={propertyPurposes}
                editable={true}
                helpText={fields.propertyPurpose.helpText}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.propertyPurpose)}
                allowBlank={true}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-md-6">
              <BooleanRadio
                activateRequiredField={this.state[fields.loanPurpose.error]}
                label={fields.loanPurpose.label}
                checked={this.state[fields.loanPurpose.name]}
                keyName={fields.loanPurpose.name}
                editable={true}
                yesLabel="Purchase"
                noLabel="Refinance"
                onFocus={this.onFocus.bind(this, fields.loanPurpose)}
                onChange={this.onChange}/>
            </div>
          </div>
          {this.state[fields.loanPurpose.name] === null ? null :
            this.state[fields.loanPurpose.name] == true
            ?
              <div className="form-group">
                <div className="col-md-6">
                  <TextField
                    requiredMessage="This field is required"
                    activateRequiredField={this.state[fields.purchasePrice.error]}
                    label={fields.purchasePrice.label}
                    keyName={fields.purchasePrice.name}
                    value={this.state[fields.purchasePrice.name]}
                    editable={true}
                    liveFormat={true}
                    format={this.formatCurrency}
                    helpText={fields.purchasePrice.helpText}
                    onFocus={this.onFocus.bind(this, fields.purchasePrice)}
                    onChange={this.onChange}/>
                </div>
              </div>
            :
              <div>
                <div className="form-group">
                  <div className="col-md-6">
                    <TextField
                      requiredMessage="This field is required"
                      activateRequiredField={this.state[fields.originalPurchasePrice.error]}
                      label={fields.originalPurchasePrice.label}
                      keyName={fields.originalPurchasePrice.name}
                      value={this.state[fields.originalPurchasePrice.name]}
                      editable={true}
                      liveFormat={true}
                      format={this.formatCurrency}
                      helpText={fields.originalPurchasePrice.helpText}
                      onFocus={this.onFocus.bind(this, fields.originalPurchasePrice)}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-md-6">
                    <TextField
                      requiredMessage="This field is required"
                      activateRequiredField={this.state[fields.originalPurchaseYear.error]}
                      label={fields.originalPurchaseYear.label}
                      keyName={fields.originalPurchaseYear.name}
                      value={this.state[fields.originalPurchaseYear.name]}
                      placeholder="YYYY"
                      editable={true}
                      helpText={fields.originalPurchaseYear.helpText}
                      onFocus={this.onFocus.bind(this, fields.originalPurchaseYear)}
                      onChange={this.onChange}/>
                  </div>
                </div>
              </div>
          }
          <div className="form-group">
            <div className="col-md-12">
              <button className="btn theBtn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
            </div>
          </div>
        </form>
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  buildStateFromLoan: function(loan) {
    var property = loan.subject_property;
    var state = {};

    if (loan[fields.loanPurpose.name] == "purchase") {
      state[fields.loanPurpose.name] = true;

    } else if (loan[fields.loanPurpose.name] == "refinance") {
      state[fields.loanPurpose.name] = false;
    } else {
      state[fields.loanPurpose.name] = loan[fields.loanPurpose.name];
    }

    state["property_id"] = property.id;
    state[fields.address.name] = property.address;
    state[fields.propertyPurpose.name] = property[fields.propertyPurpose.name];
    state[fields.purchasePrice.name] = this.formatCurrency(property[fields.purchasePrice.name]);
    state[fields.originalPurchasePrice.name] = this.formatCurrency(property[fields.originalPurchasePrice.name]);
    state[fields.originalPurchaseYear.name] = property[fields.originalPurchaseYear.name];
    state["property_type"] = property.property_type;
    state["market_price"] = property.market_price;
    state["estimated_hazard_insurance"] = property.estimated_hazard_insurance;
    state["estimated_property_tax"] = property.estimated_property_tax;
    state["year_built"] = property.year_built;
    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var purpose = this.state[fields.loanPurpose.name];

    if (purpose != null) {
      if (purpose == true) {
        loan[fields.loanPurpose.name] = "purchase";
      } else {
        loan[fields.loanPurpose.name] = "refinance";
      }
    } else {
      loan[fields.loanPurpose.name] = purpose;
    }

    loan.properties_attributes = {id: this.state["property_id"]};
    loan.properties_attributes[fields.propertyPurpose.name] = this.state[fields.propertyPurpose.name];
    loan.properties_attributes[fields.purchasePrice.name] = this.currencyToNumber(this.state[fields.purchasePrice.name]);
    loan.properties_attributes[fields.originalPurchasePrice.name] = this.currencyToNumber(this.state[fields.originalPurchasePrice.name]);
    loan.properties_attributes[fields.originalPurchaseYear.name] = this.state[fields.originalPurchaseYear.name];
    loan.properties_attributes.address_attributes = this.state.address;
    loan.properties_attributes.zpid = this.state.property ? this.state.property.zpid : null;
    loan.properties_attributes.is_subject = true
    loan.properties_attributes.property_type = this.state.property_type;
    loan.properties_attributes.market_price = this.currencyToNumber(this.state.marketPrice);
    loan.properties_attributes.estimated_hazard_insurance = this.state.estimatedHazardInsurance;
    loan.properties_attributes.estimated_property_tax = this.state.estimatedPropertyTax;
    loan.properties_attributes.is_primary = this.isPrimaryProperty();
    loan.properties_attributes.year_built = this.state.yearBuilt;
    loan.properties_attributes.zillow_image_url = this.state.zillowImageUrl;

    return loan;
  },

  isPrimaryProperty: function() {
    this.state[fields.propertyPurpose.name] == "primary_residence"
  },

  save: function(event) {
    this.setState({saving: true});

    var state = {};
    if (this.state[fields.address.name] === null) {
      state[fields.address.error] = true;
    }
    if (!this.state[fields.propertyPurpose.name]) {
      state[fields.propertyPurpose.error] = true;
    }
    if (this.state[fields.loanPurpose.name] == null) {
      state[fields.loanPurpose.error] = true;
    } else {
      if (this.state[fields.loanPurpose.name] == true) {
        if (!this.state[fields.purchasePrice.name]) {
          state[fields.purchasePrice.error] = true;
        }
      } else {
        if (!this.state[fields.originalPurchasePrice.name]) {
          state[fields.originalPurchasePrice.error] = true;
        }
        if (!this.state[fields.originalPurchaseYear.name]) {
          state[fields.originalPurchaseYear.error] = true;
        }
      }
    }

    if(Object.keys(state).length != 0){
      this.setState({saving: false, isValid: false});
      this.setState(state);
    } else {
      this.setState({isValid: true});
      this.props.saveLoan(this.buildLoanFromState(), 0);
    }
    event.preventDefault();
  },

  scrollTopError: function(){
    var offset = $(".tooltip").first().parents(".form-group").offset();
    var top = offset === undefined ? 0 : offset.top;
    $('html, body').animate({scrollTop: top}, 1000);
    this.setState({isValid: true});
  }
});

module.exports = FormProperty;
