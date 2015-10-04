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
  {value: 'fourplex', name: 'Fourplex'}
];

var mortgagePayments = [
  {value: '1', name: '1'},
  {value: '2', name: '2'},
  {value: '3', name: '3'},
  {value: 'Other', name: 'Other'}
];

var otherFinancings = [
  {value: '1', name: '1'},
  {value: '2', name: '2'},
  {value: '3', name: '3'},
  {value: 'Other', name: 'Other'}
];

var mortgageInclueEscrows = [
  {value: 'taxes_and_insurance', name: "Yes, include my property taxes and insurance"},
  {value: 'taxes_only', name: "Yes, include my property taxes only"},
  {value: 'no', name: "No, I will pay my taxes and insurance myself"},
  {value: 'not_sure', name: "I'm not sure"}
];

var Property = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    var state = {};
    state.property = this.props.property
    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0];
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
      if (propertyTypes[i]['name'] == type_name) return propertyTypes[i]['value'];
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
              keyName={'property.mortgage_payment'}
              value={this.state.property.mortgage_payment}
              options={mortgagePayments}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
          { this.state.property.mortgage_payment == "Other"
            ? <div className='col-xs-6'>
                <TextField
                  label='Other'
                  keyName={'property.other_mortgage_payment'}
                  value={this.state.property.other_mortgage_payment}
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
              keyName={'property.financing'}
              value={this.state.property.financing}
              options={otherFinancings}
              editable={true}
              onChange={this.onChange}
              allowBlank={true}/>
          </div>
          { this.state.property.financing == "Other"
            ? <div className='col-xs-6'>
                <TextField
                  label='Other'
                  keyName={'property.other_financing'}
                  value={this.state.property.other_financing}
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
        <div className='row' style={{display: this.state.property.is_primary ? 'none' : null}}>
          <div className='col-xs-6'>
            <TextField
              label='Monthly rent'
              keyName={'property.gross_rental_income'}
              value={this.state.property.gross_rental_income}
              editable={true}
              onChange={this.onChange}/>
          </div>
          { this.props.isShowRemove == true
            ? <div className='box text-right col-xs-6'>
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