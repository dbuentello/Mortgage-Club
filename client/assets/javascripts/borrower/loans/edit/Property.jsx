var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var fields = {
  ownsRental: {label: '', name: 'owns_rental', helpText: null},
};

var propertyTypes = [
      {value: 'Single Family Home', name: 'Single Family Home'},
      {value: 'Duplex', name: 'Duplex'},
      {value: 'Triplex', name: 'Triplex'},
      {value: 'Fourplex', name: 'Fourplex'},
      {value: 'Condo', name: 'Condominium'}
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
      {value: '1', name: "Yes, include my property taxs and insurance"},
      {value: '2', name: "Yes, include my property taxes only"},
      {value: '3', name: "No, I will pay my taxes and insurance myself"},
      {value: '4', name: "I'm not sure"}
    ];

var Property = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],
  propTypes: {
    isPrimary: React.PropTypes.bool.isRequired,
  },

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

  remove: function(index) {
    this.props.onRemove(index);
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
              keyName={'property.market_value'}
              value={this.state.property.market_value}
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
              keyName={'property.mortgage_insurance'}
              value={this.state.property.mortgage_insurance}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className='col-xs-6'>
            <SelectField
              label='Does your mortgage payment include escrows?'
              keyName={'property.mortgage_include_escrows'}
              value={this.state.property.mortgage_include_escrows}
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
              keyName={'property.homeowner_insurance'}
              value={this.state.property.homeowner_insurance}
              editable={true}
              onChange={this.onChange}/>
          </div>
          <div className='col-xs-3'>
            <TextField
              label='Property Tax'
              keyName={'property.property_tax'}
              value={this.state.property.property_tax}
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
        <div className='row' style={{display: this.props.isPrimary ? 'none' : null}}>
          <div className='col-xs-6'>
            <TextField
              label='Monthly rent'
              keyName={'property.monthly_rent'}
              value={this.state.property.monthly_rent}
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