var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

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
    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
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
        if (response.message == 'cannot find') {
          // actually 404 error
          return;
        }
        var market_price = this.getValue(response, 'zestimate.amount.__content__');
        var propertyType = this.getPropertyType(this.getValue(response, 'useCode'));
        var monthlyTax = this.getValue(response, 'monthlyTax');
        var monthlyInsurance = this.getValue(response, 'monthlyInsurance');
        property.market_price = market_price;
        property.property_type = propertyType;
        property.estimated_property_tax = monthlyTax;
        property.estimated_hazard_insurance = monthlyInsurance;
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

  // componentDidMount: function() {
  //   var state = {};
  //   state.mortgagePayment = this.props.property.mortgage_payment ? this.props.property.mortgage_payment.id : null;
  //   state.otherFinancing = this.props.property.other_financing ? this.props.property.other_financing.id : null;
  //   state.mortgageLiabilities = this.reloadMortgageLiabilities(state.otherFinancing);
  //   state.otherFinancingLiabilities = this.reloadOtherFinancingLiabilities(state.mortgagePayment);
  //   this.setState(state);
  // },

  render: function() {
    var index = this.props.index;
    return (
      <div className={'box mtn mbm pam bas roundedCorners' + (index % 2 === 0 ? ' backgroundLowlight' : '')} >
        <div className='row'>
          <div className='col-xs-6'>
            <AddressField
              label='Address'
              address={this.state.property.address}
              keyName={'property.address'}
              editable={true}
              onChange={this.onChange}
              placeholder='Please select from one of the drop-down options'/>
          </div>
          <div className='col-xs-3'>
            <SelectField
              label='Property Type'
              keyName={'property.property_type'}
              value={this.state.property.property_type}
              options={propertyTypes}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
          <div className='col-xs-3'>
            <TextField
              label='Estimated Market Value'
              keyName={'property.market_price'}
              value={this.state.property.market_price}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <SelectField
              label='Mortgage Payment'
              keyName={'property.mortgagePayment'}
              options={this.state.mortgageLiabilities}
              value={this.state.property.mortgagePayment}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
          { this.state.setOtherMortgagePayment
            ? <div className='col-xs-6'>
                <TextField
                  label='Other Amount'
                  keyName={'property.other_mortgage_payment_amount'}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            : null
          }
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <SelectField
              label='Other Financing (if applicable)'
              keyName={'property.otherFinancing'}
              value={this.state.property.otherFinancing}
              options={this.state.otherFinancingLiabilities}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
          { this.state.setOtherFinancing
            ? <div className='col-xs-6'>
                <TextField
                  label='Other Amount'
                  keyName={'property.other_financing_amount'}
                  editable={true}
                  onChange={this.onChange}/>
              </div>
            : null
          }
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <TextField
              label='Mortgage Insurance (if applicable)'
              keyName={'property.estimated_mortgage_insurance'}
              value={this.state.property.estimated_mortgage_insurance}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className='col-xs-6'>
            <SelectField
              label='Does your mortgage payment include escrows?'
              keyName={'property.mortgage_includes_escrows'}
              value={this.state.property.mortgage_includes_escrows}
              options={mortgageInclueEscrows}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-6'>
            <TextField
              label='Homeowner’s Insurance'
              keyName={'property.estimated_hazard_insurance'}
              value={this.state.property.estimated_hazard_insurance}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className='col-xs-3'>
            <TextField
              label='Property Tax'
              keyName={'property.estimated_property_tax'}
              value={this.state.property.estimated_property_tax}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className='col-xs-3 pln'>
            <TextField
              label='HOA Due (if applicable)'
              keyName={'property.hoa_due'}
              value={this.state.property.hoa_due}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        <div className='row' style={{display: (this.state.property.is_subject && this.state.property.usage == 'rental_property') ? null : 'none'}}>
          <div className='col-xs-6'>
            <TextField
              label='Estimated Rental Income'
              keyName={'property.gross_rental_income'}
              value={this.state.property.gross_rental_income}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        <div className='row'>
          { this.props.isShowRemove == true
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