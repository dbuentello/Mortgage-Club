var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var FlashHandler = require("mixins/FlashHandler");
var ValidationObject = require("mixins/FormValidationMixin");
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');

var AddressField = require("components/form/NewAddressField");
var SelectField = require("components/form/NewSelectField");
var TextField = require("components/form/NewTextField");
var BooleanRadio = require("components/form/NewBooleanRadio");
var fields = {
  address: {label: 'Property Address', name: 'address', error: "addressError", validationTypes: ["empty", "address"]},
  loanPurpose: {label: "Purpose Of Loan", name: "purpose", error: "loanError", validationTypes: ["empty"]},
  grossRentalIncome: {label: "Estimated Rental Income", name: "gross_rental_income", error: "grossRentalIncomeError", validationTypes: ["empty", "currency"]},
  propertyPurpose: {label: "Property Will Be", name: "usage", error: "propertyError", validationTypes: ["empty"]},
  purchasePrice: {label: "Purchase Price", name: "purchase_price", error: "purchaseError", validationTypes: ["empty", "currency"]},
  originalPurchasePrice: {label: "Original Purchase Price", name: "original_purchase_price", error: "originalPurchasePriceError", validationTypes: ["empty", "currency"]},
  originalPurchaseYear: {label: "Purchase Year", name: "original_purchase_year", error: "originalPurchaseYearError", validationTypes: ["empty", "integer"]},
  estimatedMortgageBalance: {label: "Estimated Mortgage Balance", name: "estimated_mortgage_balance", error: "estimatedMortgageBalanceError", validationTypes: ["empty", "currency"]},
  yearBuilt: {label: "Year Built", name: "year_built", error: "yearBuiltError", validationTypes: ["empty"]},
  downPayment: {label: "Down Payment", name: "down_payment"}
};

var loanPurposes = [
  {value: "purchase", name: "Purchase"},
  {value: "refinance", name: "Refinance"}
];

var propertyPurposes = [
  {value: "primary_residence", name: "Primary Residence"},
  {value: "vacation_home", name: "Vacation Home"},
  {value: "rental_property", name: "Investment Property"}
];

var propertyTypes = [
  {value: "sfh", name: "Single Family Home"},
  {value: "duplex", name: "Duplex"},
  {value: "triplex", name: "Triplex"},
  {value: "fourplex", name: "Fourplex"},
  {value: "condo", name: "Condo"}
];

var FormProperty = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin, FlashHandler, ValidationObject, CheckCompletedLoanMixin],

  getInitialState: function() {
    var state = this.buildStateFromLoan(this.props.loan);
    state.isValid = true;
    return state;
  },

  componentDidUpdate: function(){
    if(!this.state.isValid)
      this.scrollTopError();
  },

  componentDidMount: function(){
    $("body").scrollTop(0);
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

  onBlur: function(blur) {
    this.setState(blur);
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
        var annualTax = this.getValue(response, 'annualTax');
        var annualInsurance = this.getValue(response, 'annualInsurance');
        var yearBuilt = this.getValue(response, 'yearBuilt');
        var lastSoldDate = this.getValue(response, 'lastSoldDate');
        var lastSoldPrice = this.getValue(response, 'lastSoldPrice.__content__');
        var purchaseYear = (lastSoldDate ? new Date(Date.parse(lastSoldDate)).getFullYear() : null);
        var zillowImageUrl = this.getValue(response, 'zillowImageUrl');
        var propertyType = this.getPropertyType(this.getValue(response, 'useCode'));
        var rentalIncome = this.getValue(response, 'rentzestimate.amount.__content__');

        var state = {} ;
        state.marketPrice = this.formatCurrency(marketPrice);
        state.estimatedPropertyTax = annualTax;
        state.estimatedHazardInsurance = annualInsurance;
        state.yearBuilt = yearBuilt;
        state.zillowImageUrl = zillowImageUrl;
        state[fields.originalPurchasePrice.name] = this.formatCurrency(lastSoldPrice);
        state[fields.grossRentalIncome.name] = this.formatCurrency(rentalIncome);
        state[fields.originalPurchaseYear.name] = purchaseYear;
        state.property_type = propertyType;
        this.setState(state);
      }
    });
  },

  getPropertyType: function(type_name) {
    for (var i=0, iLen=propertyTypes.length; i<iLen; i++) {
      if (propertyTypes[i]['value'] == type_name) return propertyTypes[i]['value'];
    }
    return null;
  },

  render: function() {
    return (
      <div className="col-sm-9 col-xs-12 account-content">
        <div className='form-group'>
          <p className="box-description col-sm-12">
            We understand a loan application can be a bit overwhelming but we’re here to help. Our software will try to extract data from other sources so don’t be surprised if several fields are automatically filled in for you. Let’s get started, shall we?
          </p>
        </div>
        <form className="form-horizontal">
          <div className="form-group">
            <div className="col-md-12">
              <AddressField
                invalidMessage="Sorry, we only lend in CA at this time. More states are coming soon!"
                label={fields.address.label}
                activateRequiredField={this.state[fields.address.error]}
                address={this.state[fields.address.name]}
                keyName={fields.address.name}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.address)}
                validationTypes={["address"]}
                editMode={this.props.editMode}/>
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
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.propertyPurpose)}
                allowBlank={true}
                editMode={this.props.editMode}/>
            </div>
            {
              this.state[fields.propertyPurpose.name] != "primary_residence" && this.state[fields.propertyPurpose.name] != ""  && this.state[fields.propertyPurpose.name] != null
              ?
                <div className="col-md-6">
                  <TextField
                    requiredMessage="This field is required"
                    activateRequiredField={this.state[fields.grossRentalIncome.error]}
                    label={fields.grossRentalIncome.label}
                    keyName={fields.grossRentalIncome.name}
                    value={this.state[fields.grossRentalIncome.name]}
                    editable={true}
                    maxLength={15}
                    format={this.formatCurrency}
                    onFocus={this.onFocus.bind(this, fields.grossRentalIncome)}
                    validationTypes={["currency"]}
                    onChange={this.onChange}
                    onBlur={this.onBlur}
                    editMode={this.props.editMode}/>
                </div>
              :
                null
            }
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
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          {this.state[fields.loanPurpose.name] === null ? null :
            this.isPurchase()
            ?
              <div>
                <div className="row">
                  <div className="col-md-12">
                    <div className="form-group">
                      <div className="col-md-6">
                        <TextField
                          requiredMessage="This field is required"
                          activateRequiredField={this.state[fields.purchasePrice.error]}
                          label={fields.purchasePrice.label}
                          keyName={fields.purchasePrice.name}
                          value={this.state[fields.purchasePrice.name]}
                          editable={true}
                          maxLength={15}
                          format={this.formatCurrency}
                          onFocus={this.onFocus.bind(this, fields.purchasePrice)}
                          validationTypes={["currency"]}
                          onBlur={this.onBlur}
                          onChange={this.onChange}
                          editMode={this.props.editMode}
                          placeholder={"e.g. 500,000"}/>
                      </div>
                    </div>
                  </div>

                  <div className="col-md-12">
                     <div className="form-group">
                      <div className="col-md-6">
                        <TextField
                          label={fields.downPayment.label}
                          keyName={fields.downPayment.name}
                          value={this.state[fields.downPayment.name]}
                          editable={true}
                          maxLength={15}
                          format={this.formatCurrency}
                          onFocus={this.onFocus.bind(this, fields.downPayment)}
                          onBlur={this.onBlur}
                          onChange={this.onChange}
                          editMode={this.props.editMode}
                          placeholder={"e.g. 100,000"}/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            :
              <div>
                <div className="row">
                  <div className="col-md-6">
                    <div className="form-group">
                      <div className="col-md-12">
                        <TextField
                          requiredMessage="This field is required"
                          activateRequiredField={this.state[fields.originalPurchasePrice.error]}
                          label={fields.originalPurchasePrice.label}
                          keyName={fields.originalPurchasePrice.name}
                          value={this.state[fields.originalPurchasePrice.name]}
                          editable={true}
                          maxLength={15}
                          format={this.formatCurrency}
                          onFocus={this.onFocus.bind(this, fields.originalPurchasePrice)}
                          validationTypes={["currency"]}
                          onBlur={this.onBlur}
                          onChange={this.onChange}
                          editMode={this.props.editMode}/>
                      </div>
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <div className="col-md-12">
                        <TextField
                          requiredMessage="This field is required"
                          activateRequiredField={this.state[fields.originalPurchaseYear.error]}
                          label={fields.originalPurchaseYear.label}
                          keyName={fields.originalPurchaseYear.name}
                          value={this.state[fields.originalPurchaseYear.name]}
                          editable={true}
                          maxLength={4}
                          liveFormat={true}
                          format={this.formatYear}
                          onFocus={this.onFocus.bind(this, fields.originalPurchaseYear)}
                          validationTypes={["integer"]}
                          onChange={this.onChange}
                          editMode={this.props.editMode}/>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="row">
                  <div className="col-md-6">
                    <div className="form-group">
                      <div className="col-md-12">
                        <TextField
                          requiredMessage="This field is required"
                          activateRequiredField={this.state[fields.estimatedMortgageBalance.error]}
                          label={fields.estimatedMortgageBalance.label}
                          keyName={fields.estimatedMortgageBalance.name}
                          value={this.state[fields.estimatedMortgageBalance.name]}
                          editable={true}
                          maxLength={15}
                          format={this.formatCurrency}
                          onFocus={this.onFocus.bind(this, fields.estimatedMortgageBalance)}
                          validationTypes={["currency"]}
                          onBlur={this.onBlur}
                          onChange={this.onChange}
                          editMode={this.props.editMode}/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
          }
          <div className="form-group">
            <div className="col-md-12">
            {
              this.props.editMode
              ?
                <button className="btn text-uppercase" id="continueBtn" onClick={this.save}>{ this.state.saving ? 'Saving' : 'Save and Continue' }<img src="/icons/arrowRight.png" alt="arrow"/></button>
              :
                <button className="btn text-uppercase" id="nextBtn" onClick={this.next}>Next<img src="/icons/arrowRight.png" alt="arrow"/></button>
            }
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

    state.property_id = property.id;
    state[fields.address.name] = property.address;
    state[fields.propertyPurpose.name] = property[fields.propertyPurpose.name];
    state[fields.purchasePrice.name] = this.formatCurrency(property[fields.purchasePrice.name]);
    state[fields.grossRentalIncome.name] = this.formatCurrency(property[fields.grossRentalIncome.name]);
    state[fields.originalPurchasePrice.name] = this.formatCurrency(property[fields.originalPurchasePrice.name]);
    state[fields.originalPurchaseYear.name] = property[fields.originalPurchaseYear.name];
    state[fields.estimatedMortgageBalance.name] = this.formatCurrency(property[fields.estimatedMortgageBalance.name]);
    state[fields.downPayment.name] = loan[fields.downPayment.name] != 0 ? this.formatCurrency(loan[fields.downPayment.name]) : null;
    state.property_type = property.property_type;
    state.market_price = property.market_price;
    state.estimated_hazard_insurance = property.estimated_hazard_insurance;
    state.estimated_property_tax = property.estimated_property_tax;
    state.year_built = property.year_built;

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    var purpose = this.state[fields.loanPurpose.name];

    if (this.isPurchase()) {
      loan[fields.loanPurpose.name] = "purchase";
      loan[fields.downPayment.name] = this.currencyToNumber(this.state[fields.downPayment.name]);
    } else {
      loan[fields.loanPurpose.name] = "refinance";
    }

    return loan;
  },

  buildSubjectPropertyFromState: function() {
    var property = {};

    property.id = this.state.property_id;
    property[fields.propertyPurpose.name] = this.state[fields.propertyPurpose.name];
    property.zpid = this.state.property ? this.state.property.zpid : null;
    property.is_subject = true;
    property.property_type = this.state.property_type;

    if(!this.isPrimaryProperty()) {
      property[fields.grossRentalIncome.name] = this.currencyToNumber(this.state[fields.grossRentalIncome.name]);
    }

    if(this.isPurchase()){
      property[fields.purchasePrice.name] = this.currencyToNumber(this.state[fields.purchasePrice.name]);
      property.market_price = this.currencyToNumber(this.state[fields.purchasePrice.name]);
    }else{
      property[fields.originalPurchasePrice.name] = this.currencyToNumber(this.state[fields.originalPurchasePrice.name]);
      property[fields.originalPurchaseYear.name] = this.state[fields.originalPurchaseYear.name];
      property[fields.estimatedMortgageBalance.name] = this.currencyToNumber(this.state[fields.estimatedMortgageBalance.name]);
      property.market_price = this.currencyToNumber(this.state.marketPrice);
    }

    property.estimated_hazard_insurance = this.state.estimatedHazardInsurance;
    property.estimated_property_tax = this.state.estimatedPropertyTax;
    property.is_primary = this.isPrimaryProperty();
    property.year_built = this.state.yearBuilt;
    property.zillow_image_url = this.state.zillowImageUrl;

    return property;
  },

  buildAddressFromState: function() {
    return this.state.address;
  },

  isPrimaryProperty: function() {
    return this.state[fields.propertyPurpose.name] == "primary_residence";
  },

  isRefinance: function() {
    if(this.state[fields.loanPurpose.name] == false) {
      return true;
    }

    return false;
  },

  isPurchase: function() {
    if(this.state[fields.loanPurpose.name] == true) {
      return true;
    }

    return false;
  },

  mapValueToRequiredFields: function() {
    var requiredFields = {};

    requiredFields[fields.address.error] = {value: this.state[fields.address.name], validationTypes: fields.address.validationTypes};
    requiredFields[fields.propertyPurpose.error] = {value: this.state[fields.propertyPurpose.name], validationTypes: fields.propertyPurpose.validationTypes};
    requiredFields[fields.loanPurpose.error] = {value: this.state[fields.loanPurpose.name], validationTypes: fields.loanPurpose.validationTypes};

    if(this.isPurchase()) {
      requiredFields[fields.purchasePrice.error] = {value: this.state[fields.purchasePrice.name], validationTypes: fields.purchasePrice.validationTypes};
      requiredFields[fields.downPayment.error] = {value: this.state[fields.downPayment.name], validationTypes: fields.downPayment.validationTypes};
    }

    if(this.isRefinance()) {
      requiredFields[fields.originalPurchasePrice.error] = {value: this.state[fields.originalPurchasePrice.name], validationTypes: fields.originalPurchasePrice.validationTypes};
      requiredFields[fields.originalPurchaseYear.error] = {value: this.state[fields.originalPurchaseYear.name], validationTypes: fields.originalPurchaseYear.validationTypes};
    }

    if(!this.isPrimaryProperty()) {
      requiredFields[fields.grossRentalIncome.error] = {value: this.state[fields.grossRentalIncome.name], validationTypes: fields.grossRentalIncome.validationTypes};
    }

    return requiredFields;
  },

  valid: function() {
    var isValid = true;
    var requiredFields = this.mapValueToRequiredFields();
    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }
    return isValid;
  },

  save: function(event) {
    this.setState({saving: true});

    if(this.valid()){
      this.setState({isValid: true});
      $.ajax({
        url: "/properties/",
        method: "POST",
        context: this,
        dataType: "json",
        data: {
          loan: this.buildLoanFromState(),
          subject_property: this.buildSubjectPropertyFromState(),
          address: this.buildAddressFromState(),
          loan_id: this.props.loan.id,
        },
        success: function(response) {
          this.setState({saving: false});
          if (this.loanIsCompleted(response.loan)) {
            this.props.goToAllDonePage(response.loan);
          }
          else {
            this.props.setupMenu(response, 0);
          }
        }.bind(this),
        error: function(response, status, error) {
          this.setState({saving: false});
        }
      });
    }
    else {
      this.setState({saving: false, isValid: false});
    }

    event.preventDefault();
  },

  next: function(event){
    this.props.next(1);
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
