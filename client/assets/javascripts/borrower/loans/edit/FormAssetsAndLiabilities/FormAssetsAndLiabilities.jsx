var _ = require('lodash');
var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var ValidationObject = require("mixins/FormValidationMixin");
var BooleanRadio = require('components/form/NewBooleanRadio');
var FlashHandler = require('mixins/FlashHandler');
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');
var Property = require('./Property');
var Asset = require('./Asset');

var SelectedLiabilityArr = [];

var fields = {
  ownsRental: {label: '', name: 'owns_rental', helpText: null},
};

var FormAssetsAndLiabilities = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin, FlashHandler, CheckCompletedLoanMixin, ValidationObject],

  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};
    _.each(fields, function (field) {
      state[field.name] = null;
    });

    state.liabilities = _.sortBy(this.props.liabilities, function (lib) {
      return parseFloat(lib.payment);
    });

    state.own_investment_property = this.props.loan.own_investment_property;
    state.rental_properties = this.props.loan.rental_properties;
    state.subject_property = this.props.loan.subject_property;
    state.primary_property = this.props.loan.primary_property;

    state.saving = false;
    state.isValid = true;
    state.assets = this.props.loan.borrower.assets;

    if (state.assets.length == 0) {
      var defaultAsset = this.getDefaultAsset();
      defaultAsset.asset_type = 'checkings';
      state.assets.push(defaultAsset)
    }
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
    var key = _.keys(change)[0];
    var value = _.values(change)[0];
    this.setState(this.setValue(this.state, key, value));
    if (change.own_investment_property == true && this.state.rental_properties.length == 0) {
      this.addProperty();
    }
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  eachProperty: function(property, index) {
    return (
      <Property
        key={index}
        index={index}
        property={property}
        liabilities = {this.state.liabilities}
        isShowRemove={this.state.rental_properties.length >= 1}
        onRemove={this.removeProperty}
        addressError={property.addressError}
        propertyTypeError={property.propertyTypeError}
        marketPriceError={property.marketPriceError}
        mortgageIncludesEscrowsError={property.mortgageIncludesEscrowsError}
        estimatedHazardInsuranceError={property.estimatedHazardInsuranceError}
        estimatedPropertyTaxError={property.estimatedPropertyTaxError}
        grossRentalIncomeError={property.grossRentalIncomeError}
        otherMortgagePaymentAmountError={property.otherMortgagePaymentAmountError}
        otherFinancingAmountError={property.otherFinancingAmountError}
        estimatedMortgageInsuranceError={property.estimatedMortgageInsuranceError}
        hoaDueError={property.hoaDueError}
        isPurchase={this.props.loan.purpose == "purchase"}
        editMode={this.props.editMode}/>
    );
  },

  eachAsset: function(asset, index) {
    return (
      <Asset asset={asset}
        index={index}
        key={index}
        onUpdate={this.updateAsset}
        onRemove={this.removeAsset}
        institutionNameError={asset.institutionNameError}
        assetTypeError={asset.assetTypeError}
        currentBalanceError={asset.currentBalanceError}
        editMode={this.props.editMode}/>
    );
  },
  // keepTrackOfSelectedLiabilities: function(unselectedLiability, selectedLiability) {
  //   var liabilities = [];
  //   _.remove(SelectedLiabilityArr, function(liabilityID) { return liabilityID == unselectedLiability; });
  //   if (selectedLiability) {
  //     SelectedLiabilityArr.push(selectedLiability);
  //   }

  //   _.each(this.props.bootstrapData.liabilities, function (liability) {
  //     if (SelectedLiabilityArr.indexOf(liability.id) <= -1) {
  //       liabilities.push(liability);
  //     }
  //   });

  //   console.dir(liabilities);
  //   this.setState({liabilities: liabilities});
  // },

  render: function() {
    return (
      <div className='col-sm-9 col-xs-12 account-content'>
        <form className='form-horizontal'>
          <div className='form-group'>
            <div className='col-md-12'>
              <h3 className='text-uppercase margin-top-0'>Your financial assets</h3>
              {this.state.assets.map(this.eachAsset)}
            </div>
          </div>
          {
            this.props.editMode
            ?
              <div className='form-group'>
                <div className='col-md-12 clickable' onClick={this.addAsset}>
                  <h5>
                    <span className="glyphicon glyphicon-plus-sign"></span>
                      Add asset
                  </h5>
                </div>
              </div>
            :
              null
          }

          {
            this.state.subject_property
            ?
              <div className='form-group'>
                <div className= 'col-md-12'>
                  {
                    this.props.loan.purpose == "purchase"
                    ?
                      <h3 className='text-uppercase'>{"The property you're buying"}</h3>
                    :
                      <h3 className='text-uppercase'>{"The property you're refinancing"}</h3>
                  }
                  <Property
                    index={'subject_property'}
                    property={this.state.subject_property}
                    liabilities={this.state.liabilities}
                    addressError={this.state.subject_property.addressError}
                    propertyTypeError={this.state.subject_property.propertyTypeError}
                    marketPriceError={this.state.subject_property.marketPriceError}
                    mortgageIncludesEscrowsError={this.state.subject_property.mortgageIncludesEscrowsError}
                    estimatedHazardInsuranceError={this.state.subject_property.estimatedHazardInsuranceError}
                    estimatedPropertyTaxError={this.state.subject_property.estimatedPropertyTaxError}
                    grossRentalIncomeError={this.state.subject_property.grossRentalIncomeError}
                    otherMortgagePaymentAmountError={this.state.subject_property.otherMortgagePaymentAmountError}
                    otherFinancingAmountError={this.state.subject_property.otherFinancingAmountError}
                    estimatedMortgageInsuranceError={this.state.subject_property.estimatedMortgageInsuranceError}
                    hoaDueError={this.state.subject_property.hoaDueError}
                    isPurchase={this.props.loan.purpose == "purchase"}
                    addressChange={this.addressChange}
                    editMode={this.props.editMode}/>
                </div>
              </div>
            :
              null
          }
          {
            (this.state.primary_property && this.subjectPropertyAndPrimaryPropertySameAddress() == false)
            ?
              <div className='form-group'>
                <div className='col-md-12'>
                <h3 className='text-uppercase'>Your primary residence</h3>
                  <Property
                    index={"primary_property"}
                    property={this.state.primary_property}
                    liabilities={this.state.liabilities}
                    addressError={this.state.primary_property.addressError}
                    propertyTypeError={this.state.primary_property.propertyTypeError}
                    marketPriceError={this.state.primary_property.marketPriceError}
                    mortgageIncludesEscrowsError={this.state.primary_property.mortgageIncludesEscrowsError}
                    estimatedHazardInsuranceError={this.state.primary_property.estimatedHazardInsuranceError}
                    estimatedPropertyTaxError={this.state.primary_property.estimatedPropertyTaxError}
                    grossRentalIncomeError={this.state.primary_property.grossRentalIncomeError}
                    otherMortgagePaymentAmountError={this.state.primary_property.otherMortgagePaymentAmountError}
                    otherFinancingAmountError={this.state.primary_property.otherFinancingAmountError}
                    estimatedMortgageInsuranceError={this.state.primary_property.estimatedMortgageInsuranceError}
                    hoaDueError={this.state.primary_property.hoaDueError}
                    isPurchase={this.props.loan.purpose == "purchase"}
                    editMode={this.props.editMode}/>
                </div>
              </div>
            :
              null
          }
          <div className='form-group'>
            <div className='col-md-12'>
               <h3 className='text-uppercase'>YOUR OTHER PROPERTIES</h3>
            </div>
            <div className='col-md-6'>
              <h5>Do you own other properties?</h5>
              <BooleanRadio
                label=''
                checked={this.state.own_investment_property}
                keyName={"own_investment_property"}
                editable={true}
                onChange={this.onChange}
                editMode={this.props.editMode}/>
            </div>
          </div>
          {
            this.state.own_investment_property
            ?
            <div>
              <div className='form-group'>
                <div className='col-md-12'>
                  <h5 className='title-asset-tab'>Please provide the following information for your other properties:</h5>
                </div>
              </div>
              {this.state.rental_properties.map(this.eachProperty)}
              {
                this.props.editMode
                ?
                  <div className='form-group'>
                    <div className='col-md-12 clickable' onClick={this.addProperty}>
                      <h5>
                        <span className="glyphicon glyphicon-plus-sign"></span>
                        Add property
                      </h5>
                    </div>
                  </div>
                :
                  null
              }

            </div>
            : null
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

  addProperty: function() {
    this.setState({rental_properties: this.state.rental_properties.concat(this.getDefaultProperty())});
  },

  removeProperty: function(index) {
    var arr = this.state.rental_properties;
    arr.splice(index, 1);
    this.setState({rental_properties: arr});
  },

  getDefaultProperty: function() {
    return {
      address: {},
      property_type: null,
      other_mortgage_payment: null,
      market_price: null,
      financing: null,
      mortgage_includes_escrows: null,
      estimated_mortgage_insurance: null,
      estimated_hazard_insurance: null,
      estimated_property_tax: null,
      hoa_due: null,
      gross_rental_income: null
    };
  },

  addAsset: function() {
    this.setState({assets: this.state.assets.concat(this.getDefaultAsset())});
  },

  updateAsset: function(index, asset){
    var tests = _.assign(this.state.assets[index], asset);
  },

  removeAsset: function(index) {
    var _assets = this.state.assets;
    _assets.splice(index, 1);
    this.setState({assets: _assets});
  },

  getDefaultAsset: function() {
    return {
      institution_name: null,
      asset_type: null,
      current_balance: null
    }
  },

  subjectPropertyAndPrimaryPropertySameAddress: function(){
    if (this.state.primary_property === null || this.state.subject_property === null)
      return false;

    var primary_address = this.state.primary_property.address;
    var subject_address = this.state.subject_property.address;

    if (primary_address === null || primary_address === undefined || subject_address === null || subject_address === undefined)
      return false;

    if(primary_address.city == subject_address.city &&
      primary_address.state == subject_address.state &&
      primary_address.street_address == subject_address.street_address &&
      primary_address.zip == subject_address.zip)
      return true;
    return false;
  },

  formatProperty: function(property) {
    property.address_attributes = property.address;
    property.market_price = this.currencyToNumber(property.market_price);
    property.other_mortgage_payment_amount = this.currencyToNumber(property.other_mortgage_payment_amount);
    property.other_financing_amount = this.currencyToNumber(property.other_financing_amount);
    property.estimated_mortgage_insurance = this.currencyToNumber(property.estimated_mortgage_insurance);
    property.estimated_hazard_insurance = this.currencyToNumber(property.estimated_hazard_insurance);
    property.estimated_property_tax = this.currencyToNumber(property.estimated_property_tax);
    property.hoa_due = this.currencyToNumber(property.hoa_due);
    property.gross_rental_income = this.currencyToNumber(property.gross_rental_income);

    return property;
  },

  copyProperty: function(srcProp, desProp){
    var address = desProp.address;
    address.city = srcProp.address.city;
    address.full_text = srcProp.address.full_text;
    address.state = srcProp.address.state;
    address.zip = srcProp.address.zip;
    address.street_address = srcProp.address.street_address;
    address.street_address2 = srcProp.address.street_address2;

    desProp.address_attributes = address;
    desProp.market_price = this.currencyToNumber(srcProp.market_price);
    desProp.other_mortgage_payment_amount = this.currencyToNumber(srcProp.other_mortgage_payment_amount);
    desProp.other_financing_amount = this.currencyToNumber(srcProp.other_financing_amount);
    desProp.estimated_mortgage_insurance = this.currencyToNumber(srcProp.estimated_mortgage_insurance);
    desProp.estimated_hazard_insurance = this.currencyToNumber(srcProp.estimated_hazard_insurance);
    desProp.estimated_property_tax = this.currencyToNumber(srcProp.estimated_property_tax);
    desProp.hoa_due = this.currencyToNumber(srcProp.hoa_due);
    desProp.gross_rental_income = this.currencyToNumber(srcProp.gross_rental_income);
    desProp.property_type = srcProp.property_type;
    desProp.mortgage_includes_escrows = srcProp.mortgage_includes_escrows;

    return desProp;
  },

  setStateForInvalidFieldsOfProperty: function(property) {
    var allFieldsAreOK = true;

    var fields = {
      addressError: {value: property.address, validationTypes: ["empty", "address"]},
      propertyTypeError: {value: property.property_type, validationTypes: ["empty"]},
      estimatedHazardInsuranceError: {value: this.formatCurrency(property.estimated_hazard_insurance), validationTypes: ["currency"]},
      estimatedPropertyTaxError: {value: this.formatCurrency(property.estimated_property_tax), validationTypes: ["currency"]},
      marketPriceError: {value: this.formatCurrency(property.market_price), validationTypes: ["currency"]},
    };

    if(this.props.loan.purpose != "purchase" || (property.is_primary != true && property.is_subject != true))
      fields.mortgageIncludesEscrowsError = {value: this.formatCurrency(property.mortgage_includes_escrows), validationTypes: ["currency"]};
    if(property.other_mortgage_payment_amount)
      fields.otherMortgagePaymentAmountError = {value: this.formatCurrency(property.other_mortgage_payment_amount), validationTypes: ["currency"]};
    if(property.other_financing_amount)
      fields.otherFinancingAmountError = {value: this.formatCurrency(property.other_financing_amount), validationTypes: ["currency"]};
    if(property.estimated_mortgage_insurance)
      fields.estimatedMortgageInsuranceError = {value: this.formatCurrency(property.estimated_mortgage_insurance), validationTypes: ["currency"]};
    if(property.hoa_due)
      fields.hoaDueError = {value: this.formatCurrency(property.hoa_due), validationTypes: ["currency"]};
    if(property.usage != "primary_residence" && property.is_primary != true && property.is_subject != true)
      fields.grossRentalIncomeError = {value: this.formatCurrency(property.gross_rental_income), validationTypes: ["currency"]}

    var states = this.getStateOfInvalidFields(fields);

    if(!_.isEmpty(states)) {
      _.each(states, function(value, key) {
        property[key] = true;
      });
      allFieldsAreOK = false;
    }
    return allFieldsAreOK;
  },

  setStateForInvalidFieldsOfAsset: function(asset) {
    var allFieldsAreOK = true;

    var fields = {
      institutionNameError: {value: asset.institution_name, validationTypes: ["empty"]},
      assetTypeError: {value: asset.asset_type, validationTypes: ["empty"]},
      currentBalanceError: {value: this.formatCurrency(asset.current_balance), validationTypes: ["currency"]}
    }

    var states = this.getStateOfInvalidFields(fields);

    if(!_.isEmpty(states)) {
      _.each(states, function(value, key) {
        asset[key] = true;
      });
      allFieldsAreOK = false;
    }

    return allFieldsAreOK;
  },

  valid: function(){
    var isValid = true;

    if(this.state.primary_property && !this.subjectPropertyAndPrimaryPropertySameAddress()){
      if(this.setStateForInvalidFieldsOfProperty(this.state.primary_property) == false) {
        isValid = false;
      }
    }

    if(this.state.subject_property) {
      if(this.setStateForInvalidFieldsOfProperty(this.state.subject_property) == false) {
        isValid = false;
      }
    }

    if(this.state.own_investment_property) {
      _.each(this.state.rental_properties, function(property){
        if(this.setStateForInvalidFieldsOfProperty(property) == false) {
          isValid = false;
        }
      }, this)
    }

    _.each(this.state.assets, function(asset) {
      if(this.setStateForInvalidFieldsOfAsset(asset) == false) {
        isValid = false;
      }
    }, this);

    return isValid;
  },

  scrollTopError: function(){
    var offset = $(".tooltip").first().parents(".form-group").offset();
    var top = offset === undefined ? 0 : offset.top;
    $('html, body').animate({scrollTop: top}, 1000);
    this.setState({isValid: true});
  },

  addressChange: function(){
    this.forceUpdate();
  },

  next: function(event){
    this.props.next(6);
    event.preventDefault();
  },

  save: function(event) {
    event.preventDefault();

    if (this.valid() == false){
      this.setState({saving: false, isValid: false});
      return false;
    }

    this.setState({saving: true, isValid: true});

    var subject_property = this.state.subject_property;
    if (subject_property){
      subject_property = this.formatProperty(subject_property);
    }

    var primary_property = this.state.primary_property;
    if (primary_property){
      if(this.subjectPropertyAndPrimaryPropertySameAddress()){
        primary_property = this.copyProperty(subject_property, primary_property);
      }
      else{
        primary_property = this.formatProperty(primary_property);
      }
    }

    var rental_properties = [];
    for (var i = 0; i < this.state.rental_properties.length; i++) {
      var rental_property = this.state.rental_properties[i];
      rental_property.usage = 'rental_property';
      rental_property = this.formatProperty(rental_property);
      rental_properties.push(rental_property);
    }

    var _assets = [];
    _.each(this.state.assets, function(asset){
      asset.current_balance = this.currencyToNumber(asset.current_balance);
      _assets.push(asset);
    }, this);

    $.ajax({
      url: '/borrower_assets',
      method: 'POST',
      context: this,
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({assets: _assets}),
      success: function(resp){
        $.ajax({
          url: '/liabilities',
          method: 'POST',
          context: this,
          dataType: 'json',
          data: {
            loan_id: this.props.loan.id,
            primary_property: this.state.primary_property,
            subject_property: this.state.subject_property,
            rental_properties: this.state.rental_properties,
            own_investment_property: this.state.own_investment_property
          },
          success: function(response) {
            this.props.bootstrapData.liabilities = response.liabilities;
            if (this.loanIsCompleted(response.loan)) {
              this.props.goToAllDonePage(response.loan);
            }
            else {
              this.props.setupMenu(response, 5);
            }
          }.bind(this),
          error: function(response, status, error) {
            this.setState({saving: false});
          }
        });
      },
      error: function(response, status, error) {
        this.setState({saving: false});
      }.bind(this)
    });
  }
});

module.exports = FormAssetsAndLiabilities;
