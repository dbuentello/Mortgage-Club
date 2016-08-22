var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var AddressField = require('components/form/NewAddressField');
var SelectField = require('components/form/NewSelectField');
var TextField = require('components/form/NewTextField');

var propertyTypes = [
  {value: 'sfh', name: 'Single Family Home'},
  {value: 'duplex', name: 'Duplex'},
  {value: 'triplex', name: 'Triplex'},
  {value: 'fourplex', name: 'Fourplex'},
  {value: 'condo', name: 'Condo'}
];

var mortgageInclueEscrows = [
  {value: "taxes_and_insurance", name: "Yes, include my property taxes and insurance"},
  {value: "taxes_only", name: "Yes, include my property taxes only"},
  {value: "no", name: "No, it doesn't include taxes or insurance"},
  {value: "not_sure", name: "I'm not sure"}
];
var otherFinancingID;
var mortgagePaymentID;

var Property = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    var state = {};
    state.property = this.props.property;
    state.property.mortgagePayment = this.props.property.mortgage_payment_liability ? this.props.property.mortgage_payment_liability.id : null;
    state.property.otherFinancing = this.props.property.other_financing_liability ? this.props.property.other_financing_liability.id : null;
    state.mortgageLiabilities = this.reloadMortgageLiabilities(state.property.otherFinancing);
    state.otherFinancingLiabilities = this.reloadOtherFinancingLiabilities(state.property.mortgagePayment);
    // state.mortgageLiabilities = this.reloadMortgageLiabilities(state.otherFinancing);
    // state.otherFinancingLiabilities = this.reloadOtherFinancingLiabilities(state.mortgagePayment);
    state.setOtherMortgagePayment = false;
    state.setOtherFinancing = false;

    state.property.market_price = state.property.market_price ? this.formatCurrency(state.property.market_price) : null;
    state.property.estimated_property_tax = state.property.estimated_property_tax ? this.formatCurrency(state.property.estimated_property_tax) : null;
    state.property.estimated_hazard_insurance = state.property.estimated_hazard_insurance ? this.formatCurrency(state.property.estimated_hazard_insurance) : null;
    state.property.other_mortgage_payment_amount = state.property.other_mortgage_payment_amount ? this.formatCurrency(state.property.other_mortgage_payment_amount) : null;
    state.property.other_remaining_balance = state.property.other_remaining_balance ? this.formatCurrency(state.property.other_remaining_balance) : null;
    state.property.other_financing_amount = state.property.other_financing_amount ? this.formatCurrency(state.property.other_financing_amount) : null;
    state.property.hoa_due = state.property.hoa_due ? this.formatCurrency(state.property.hoa_due) : null;
    state.property.gross_rental_income = state.property.gross_rental_income ? this.formatCurrency(state.property.gross_rental_income) : null;
    state.property.estimated_mortgage_insurance = state.property.estimated_mortgage_insurance ? this.formatCurrency(state.property.estimated_mortgage_insurance) : null;

    return state;
  },

  onChange: function(change) {
    var index = this.props.index;

    var key = _.keys(change)[0].replace("_" + this.props.index, '');
    key = key.replace("_", ".");
    var value = _.values(change)[0];

    if (key == 'property.mortgagePayment') {
      if (value == 'Mortgage') {
        this.setState({setOtherMortgagePayment: true});
      }
      else {
        // var unSelectedLiability = this.state.selectedMortgageLiability;
        // this.setState({selectedMortgageLiability: value});
        // this.props.keepTrackOfSelectedLiabilities(unSelectedLiability, value);
        this.setState({
          setOtherMortgagePayment: false,
          otherFinancingLiabilities: this.reloadOtherFinancingLiabilities(value)
        });
      }
    }

    if (key == 'property.otherFinancing') {
      if (value == 'OtherFinancing') {
        this.setState({setOtherFinancing: true});
      }
      else {
        // var unSelectedLiability = this.state.selectedOtherFinancingLiability;
        // this.setState({selectedOtherFinancingLiability: value});
        // this.props.keepTrackOfSelectedLiabilities(unSelectedLiability, this.state.selectedOtherFinancingLiability);
        this.setState({
          setOtherFinancing: false,
          mortgageLiabilities: this.reloadMortgageLiabilities(value)
        });
      }
    }

    if ( value != null ) {
      if (key.indexOf('.address') > -1 && value.city) {
        var propertyKey = key.replace('.address', '');
        var property = this.getValue(this.state, propertyKey);
        if(property.is_subject == false)
          property.market_price = null;
        property.property_type = null;
        property.estimated_property_tax = null;
        property.estimated_hazard_insurance = null;
        this.searchProperty(this.getValue(this.state, propertyKey), propertyKey);
      }
    }
    this.setState(this.setValue(this.state, key, value));
  },

  onBlur: function(change) {
    var index = this.props.index;

    var key = _.keys(change)[0].replace("_" + this.props.index, '');
    key = key.replace("_", ".");
    var value = _.values(change)[0];
    if (key == 'property.mortgagePayment') {
      if (value == 'Mortgage') {
        this.setState({setOtherMortgagePayment: true});
      }
      else {
        // var unSelectedLiability = this.state.selectedMortgageLiability;
        // this.setState({selectedMortgageLiability: value});
        // this.props.keepTrackOfSelectedLiabilities(unSelectedLiability, value);
        this.setState({
          otherFinancingLiabilities: this.reloadOtherFinancingLiabilities(value)
        });
      }
    }

    if (key == 'property.otherFinancing') {
      if (value == 'OtherFinancing') {
        this.setState({setOtherFinancing: true});
      }
      else {
        // var unSelectedLiability = this.state.selectedOtherFinancingLiability;
        // this.setState({selectedOtherFinancingLiability: value});
        // this.props.keepTrackOfSelectedLiabilities(unSelectedLiability, this.state.selectedOtherFinancingLiability);
        this.setState({
          setOtherFinancing: false,
          mortgageLiabilities: this.reloadMortgageLiabilities(value)
        });
      }
    }

    if ( value != null ) {
      if (key.indexOf('.address') > -1 && value.city) {
        var propertyKey = key.replace('.address', '');
        var property = this.getValue(this.state, propertyKey);
        property.market_price = null;
        property.property_type = null;
        property.estimated_property_tax = null;
        property.estimated_hazard_insurance = null;
        this.searchProperty(this.getValue(this.state, propertyKey), propertyKey);
      }
    }
    this.setState(this.setValue(this.state, key, value));
  },

  reloadMortgageLiabilities: function(selectedLiability) {
    var mortgageLiabilities = [];
    for (var i = 0; i < this.props.liabilities.length; i++) {
      if (this.props.liabilities[i].id != selectedLiability){
        mortgageLiabilities.push({value: this.props.liabilities[i].id, name: this.formatCurrency(this.props.liabilities[i].payment)});
      }
    }
    mortgageLiabilities.push({value: 'Mortgage', name: 'Other'});
    return mortgageLiabilities;
  },

  reloadOtherFinancingLiabilities: function(selectedLiability) {
    var otherFinancingLiabilities = [];
    for (var i = 0; i < this.props.liabilities.length; i++) {
      if (this.props.liabilities[i].id != selectedLiability){
        otherFinancingLiabilities.push({value: this.props.liabilities[i].id, name: this.formatCurrency(this.props.liabilities[i].payment)});
      }
    }
    otherFinancingLiabilities.push({value: 'OtherFinancing', name: 'Other'});
    return otherFinancingLiabilities;
  },

  componentDidMount: function() {
    if(this.props.index == "primary_property"){
      if(this.state.property.property_type === null || this.state.property.property_type === "")
        this.searchProperty(this.getValue(this.state, "property"), "property");
    }
  },

  searchProperty: function(property, propertyKey) {
    var address = property.address;
    $.ajax({
      url: '/properties/search',
      data: {
        address: [address.street_address, address.street_address2].join(' '),
        citystatezip: [address.city, address.state, address.zip].join(' ')
      },
      dataType: 'json',
      context: this,
      success: function(response) {
        if(this.props.addressChange !== undefined && this.props.index == "subject_property")
          this.props.addressChange();

        if (response.message == 'cannot find') {
          // actually 404 error
          return;
        }

        var market_price = this.getValue(response, 'zestimate.amount.__content__');
        var propertyType = this.getPropertyType(this.getValue(response, 'useCode'));
        var annualTax = this.getValue(response, 'annualTax');
        var annualInsurance = this.getValue(response, 'annualInsurance');
        var rentalIncome = this.getValue(response, 'rentzestimate.amount.__content__');

        if(property.is_subject !== true)
          property.market_price = this.formatCurrency(market_price);

        property.property_type = propertyType;
        property.estimated_property_tax = this.formatCurrency(annualTax);
        property.estimated_hazard_insurance = this.formatCurrency(annualInsurance);
        property.gross_rental_income = this.formatCurrency(rentalIncome);

        this.setState(this.setValue(this.state, propertyKey, property));
      }
    });
  },

  getPropertyType: function(type_name) {
    for (var i=0, iLen=propertyTypes.length; i<iLen; i++) {
      if (propertyTypes[i]['value'] == type_name) return propertyTypes[i]['value'];
    }
    return null;
  },

  remove: function(index) {
    if (this.state.property.id != null) {
      $.ajax({
        url: '/properties/' + this.state.property.id,
        method: 'DELETE',
        context: this,
        dataType: 'json',
        success: function(response) {
          this.props.onRemove(index);
        },
        error: function(response, status, error) {
          alert(error);
        }
      });
    } else {
      this.props.onRemove(index);
    }
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    var index = this.props.index;
    return (
      <div>
        <div className='form-group'>
          <div className='col-md-12'>
            <AddressField
              activateRequiredField={this.props.addressError}
              label='Address'
              address={this.state.property.address}
              keyName={'property_address_' + this.props.index}
              editable={true}
              onChange={this.onChange}
              validationTypes={["address"]}
              editMode={this.state.property.is_subject == true ? false : true}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-md-6'>
            <SelectField
              activateRequiredField={this.props.propertyTypeError}
              label='Property Type'
              keyName={'property_property_type_' + this.props.index}
              value={this.state.property.property_type}
              options={propertyTypes}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}
              editMode={this.props.editMode}/>
          </div>
          <div className='col-md-6'>
            <TextField
              activateRequiredField={this.props.marketPriceError}
              label='Estimated Market Value'
              keyName={'property_market_price_' + this.props.index}
              value={this.state.property.market_price}
              validationTypes={["currency"]}
              editable={true}
              maxLength={15}
              onChange={this.onChange}
              format={this.formatCurrency}
              onBlur={this.onBlur}
              editMode={this.props.editMode}/>
          </div>
        </div>
        {
          this.props.isPurchase == true && this.state.property.is_subject == true
          ?
            null
          :
            <div>
              <div className='form-group'>
                <div className='col-md-6'>
                  <SelectField
                    label='Mortgage Payment'
                    keyName={'property_mortgagePayment_' + this.props.index}
                    options={this.state.mortgageLiabilities}
                    value={this.state.property.mortgagePayment}
                    editable={true}
                    onChange={this.onChange}
                    allowBlank={true}
                    editMode={this.props.editMode}/>
                </div>
                { this.state.setOtherMortgagePayment
                  ?
                    <div>
                      <div className='col-md-3'>
                        <TextField
                          label='Monthly Payment'
                          keyName={'property_other_mortgage_payment_amount_' + this.props.index}
                          value={this.state.property.other_mortgage_payment_amount}
                          format={this.formatCurrency}
                          editable={true}
                          maxLength={15}
                          validationTypes={["currency"]}
                          onChange={this.onChange}
                          onBlur={this.onBlur}
                          editMode={this.props.editMode}/>
                      </div>
                      <div className='col-md-3'>
                        <TextField
                          label='Remaining Balance'
                          keyName={'property_other_remaining_balance_' + this.props.index}
                          value={this.state.property.other_remaining_balance}
                          format={this.formatCurrency}
                          editable={true}
                          maxLength={15}
                          validationTypes={["currency"]}
                          onChange={this.onChange}
                          onBlur={this.onBlur}
                          editMode={this.props.editMode}/>
                      </div>
                    </div>
                  : null
                }
              </div>
              <div className='form-group'>
                <div className='col-md-6'>
                  <SelectField
                    label='Other Financing (if applicable)'
                    keyName={'property_otherFinancing_' + this.props.index}
                    value={this.state.property.otherFinancing}
                    options={this.state.otherFinancingLiabilities}
                    editable={true}
                    onChange={this.onChange}
                    allowBlank={true}
                    editMode={this.props.editMode}/>
                </div>
                { this.state.setOtherFinancing
                  ? <div className='col-md-6'>
                      <TextField
                        label='Other Amount'
                        keyName={'property_other_financing_amount_' + this.props.index}
                        value={this.state.property.other_financing_amount}
                        format={this.formatCurrency}
                        editable={true}
                        maxLength={15}
                        validationTypes={["currency"]}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={this.props.editMode}/>
                    </div>
                  : null
                }
              </div>
              <div className='form-group'>
                <div className='col-md-6'>
                  <TextField
                    label='Mortgage Insurance (if applicable)'
                    keyName={'property_estimated_mortgage_insurance_' + this.props.index}
                    value={this.state.property.estimated_mortgage_insurance}
                    editable={true}
                    maxLength={15}
                    validationTypes={["currency"]}
                    onChange={this.onChange}
                    format={this.formatCurrency}
                    onBlur={this.onBlur}
                    editMode={this.props.editMode}/>
                </div>
                <div className='col-md-6'>
                  <SelectField
                    activateRequiredField={this.props.mortgageIncludesEscrowsError}
                    label='Does your mortgage payment include escrows?'
                    keyName={'property_mortgage_includes_escrows_' + this.props.index}
                    value={this.state.property.mortgage_includes_escrows}
                    options={mortgageInclueEscrows}
                    editable={true}
                    onChange={this.onChange}
                    allowBlank={true}
                    editMode={this.props.editMode}/>
                </div>
              </div>
            </div>
        }
        <div className='form-group'>
          <div className='col-md-4'>
            <TextField
              activateRequiredField={this.props.estimatedHazardInsuranceError}
              label='Annual Homeowners Insurance'
              keyName={'property_estimated_hazard_insurance_' + this.props.index}
              value={this.state.property.estimated_hazard_insurance}
              editable={true}
              maxLength={15}
              validationTypes={["currency"]}
              onChange={this.onChange}
              format={this.formatCurrency}
              onBlur={this.onBlur}
              editMode={this.props.editMode}/>
          </div>
          <div className='col-md-4'>
            <TextField
              activateRequiredField={this.props.estimatedPropertyTaxError}
              label='Annual Property Tax'
              keyName={'property_estimated_property_tax_' + this.props.index}
              value={this.state.property.estimated_property_tax}
              editable={true}
              maxLength={15}
              validationTypes={["currency"]}
              onChange={this.onChange}
              format={this.formatCurrency}
              onBlur={this.onBlur}
              editMode={this.props.editMode}/>
          </div>
          <div className='col-md-4'>
            <TextField
              label='Monthly HOA Due (if applicable)'
              keyName={'property_hoa_due_' + this.props.index}
              value={this.state.property.hoa_due}
              editable={true}
              maxLength={15}
              validationTypes={["currency"]}
              onChange={this.onChange}
              format={this.formatCurrency}
              onBlur={this.onBlur}
              editMode={this.props.editMode}/>
          </div>
        </div>
        <div className='form-group'>
          {
            this.props.index != "subject_property" && this.props.index != "primary_property"
            ?
              <div className='col-md-4'>
                <TextField
                  activateRequiredField={this.props.grossRentalIncomeError}
                  label='Estimated Rental Income'
                  keyName={'property_gross_rental_income_' + this.props.index}
                  value={this.state.property.gross_rental_income}
                  maxLength={15}
                  editable={true}
                  validationTypes={["currency"]}
                  onChange={this.onChange}
                  format={this.formatCurrency}
                  onBlur={this.onBlur}
                  editMode={this.props.editMode}/>
              </div>
            :
              null
          }
        </div>
        <div className='form-group'>
          { this.props.isShowRemove == true && this.props.editMode == true
            ? <div className='box text-right col-xs-11'>
                <a className="remove clickable" onClick={this.remove.bind(this, index)}>
                  Remove
                </a>
              </div>
            : null
          }
        </div>
      </div>
    );
  }
});

module.exports = Property;