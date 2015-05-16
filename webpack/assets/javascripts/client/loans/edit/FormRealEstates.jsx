var _ = require('lodash');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var HelpTooltip = require('components/form/HelpTooltip');
var BooleanRadio = require('components/form/BooleanRadio');

var fields = {
  ownsRental: {label: 'Do you own rental properties?', name: 'owns_rental', helpText: null},
};

var FormRealEstates = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};

    _.each(fields, function (field) {
      state[field.name] = null;
    });

    state.rental_properties = this.getDefaultProperties();

    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0];

    if (key.indexOf('.address') > -1 && value.city) {
      var propertyKey = key.replace('.address', '');
      this.searchProperty(this.getValue(this.state, propertyKey), propertyKey);
    }

    this.setState(this.setValue(this.state, key, value));
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
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
        var marketValue = this.getValue(response, 'zestimate.amount.__content__');
        var propertyType = this.getValue(response, 'useCode');
        var monthlyTax = this.getValue(response, 'monthlyTax');
        var monthlyInsurance = this.getValue(response, 'monthlyInsurance');

        property.market_price = property.market_price || marketValue;
        property.property_type = property.property_type || propertyType;
        property.estimated_property_tax = property.estimated_property_tax || monthlyTax;
        property.estimated_hazard_insurance = property.estimated_hazard_insurance || monthlyInsurance;
        this.setState(this.setValue(this.state, propertyKey, property));
      }
    });
  },

  render: function() {
    var propertyTypes = [
      {value: 'sfh', name: 'Single Family Home'},
      {value: 'duplex', name: 'Duplex'},
      {value: 'triplex', name: 'Triplex'},
      {value: 'Fourplex', name: 'Fourplex'}
    ];
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn'>
              <BooleanRadio
                label={fields.ownsRental.label}
                checked={this.state[fields.ownsRental.name]}
                keyName={fields.ownsRental.name}
                editable={true}
                onChange={this.onChange}/>
            </div>

            {this.state.owns_rental ?
              <div>
                <div className='h5 typeDeemphasize'>Please provide the following information for all of your rental properties:</div>
                {_.map(this.state.rental_properties, function (property, index) {
                  return (
                    <div key={index} className={'box mtn mbm pam bas roundedCorners' + (index % 2 === 0 ? ' backgroundLowlight' : '')}>
                      <div className='row'>
                        <div className='col-xs-6'>
                          <AddressField label='Address'
                            address={property.address}
                            keyName={'rental_properties[' + index + '].address'}
                            editable={true}
                            onChange={this.onChange}
                            placeholder='Please select from one of the drop-down options'/>
                        </div>
                        <div className='col-xs-6'>
                          <SelectField
                            label='Property Type'
                            keyName={'rental_properties[' + index + '].property_type'}
                            value={property.property_type}
                            options={propertyTypes}
                            editable={true}
                            onChange={this.onChange}
                            allowBlank={true}/>
                        </div>
                      </div>
                      <div className='row'>
                        <div className='col-xs-6'>
                          <TextField
                            label='Estimated Market Value'
                            keyName={'rental_properties[' + index + '].market_price'}
                            value={property.market_price}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                        <div className='col-xs-3'>
                          <TextField
                            label='Estimated Tax'
                            keyName={'rental_properties[' + index + '].estimated_property_tax'}
                            value={property.estimated_property_tax}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                        <div className='col-xs-3 pln'>
                          <TextField
                            label='Estimated Insurance'
                            keyName={'rental_properties[' + index + '].estimated_hazard_insurance'}
                            value={property.estimated_hazard_insurance}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                      </div>
                      <div className='row'>
                        <div className='col-xs-6'>
                          <TextField
                            label='Rental Income'
                            keyName={'rental_properties[' + index + '].gross_rental_income'}
                            value={property.gross_rental_income}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                        <div className='row col-xs-6 man pan'>
                          <div className='col-xs-8'>
                            <BooleanRadio
                              label='Is this property an impound?'
                              checked={property.is_impound_account}
                              keyName={'rental_properties[' + index + '].is_impound_account'}
                              editable={true}
                              onChange={this.onChange}/>
                          </div>
                          {this.state.rental_properties.length > 1 ?
                            <div className='col-xs-4 text-right'>
                              <a className='clickable linkLowlight' onClick={this.removeProperty.bind(this, index)}>
                                Remove Property
                              </a>
                            </div>
                          : null}
                        </div>
                      </div>
                    </div>
                  );
                }, this)}
                <div>
                  <a className='btn btnSml btnAction phm' onClick={this.addProperty}>
                    <i className='icon iconPlus mrxs'/> Add property
                  </a>
                </div>
              </div>
            : null}
          </div>

          <div className='box text-right phl'>
            <a className='btn btnSml btnPrimary'>Next</a>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField && this.state.focusedField.helpText
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
        </div>
      </div>
    );
  },

  addProperty: function() {
    this.setState({rental_properties: this.state.rental_properties.concat(this.getDefaultProperties())});
  },

  removeProperty: function(index) {
    this.setState({rental_properties: {$splice: [[index, 1]]}});
  },

  getDefaultProperties: function() {
    return [{
      address: {},
      property_type: null,
      market_price: null,
      estimated_property_tax: null,
      estimated_hazard_insurance: null,
      gross_rental_income: null,
      is_impound_account: null
    }];
  }
});

module.exports = FormRealEstates;
