var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var BooleanRadio = require('components/form/BooleanRadio');
var Property = require('./Property');

var fields = {
  ownsRental: {label: '', name: 'owns_rental', helpText: null},
};


var FormAssetsAndLiabilities = React.createClass({
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
        if (response.message == 'cannot find') {
          // actually 404 error
          return;
        }

        var marketValue = this.getValue(response, 'zestimate.amount.__content__');
        var propertyType = this.getValue(response, 'useCode');
        var monthlyTax = this.getValue(response, 'monthlyTax');
        var monthlyInsurance = this.getValue(response, 'monthlyInsurance');
        property.market_price = marketValue;
        property.property_type = propertyType;
        property.estimated_property_tax = monthlyTax;
        property.estimated_hazard_insurance = monthlyInsurance;
        this.setState(this.setValue(this.state, propertyKey, property));
      }
    });
  },

  eachProperty: function(property, index) {
    return (
      <Property
        key={index}
        index={index}
        property={property}
        isPrimary={false}
        isShowRemove={this.state.rental_properties.length > 1}
        onRemove={this.removeProperty}/>
    );
  },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn'>
              <h5 className='typeDeemphasize'>Your primary residence</h5>
              <Property property={this.getPrimaryProperty} isPrimary={true} />
            </div>
          </div>

          <div className='pal'>
            <div className='box mvn'>
              <h5 className='typeDeemphasize'>Do you own investment property?</h5>
              <BooleanRadio
                label={fields.ownsRental.label}
                checked={this.state[fields.ownsRental.name]}
                keyName={fields.ownsRental.name}
                editable={true}
                onChange={this.onChange}/>
            </div>

            {this.state.owns_rental ?
              <div>
                <div className='h5 typeDeemphasize'>
                  Please provide the following information for all of your rental properties:
                </div>
                {this.state.rental_properties.map(this.eachProperty)}
                <div>
                  <a className='btn btnSml btnAction phm' onClick={this.addProperty}>
                    <i className='icon iconPlus mrxs'/> Add property
                  </a>
                </div>
              </div>
              : null
            }
          </div>

          <div className='box text-right phl'>
            <a className='btn btnSml btnPrimary'>Next</a>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField && this.state.focusedField.helpText
            ? <div>
                <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
                <br/>
                {this.state.focusedField.helpText}
              </div>
            : null
          }
        </div>
      </div>
    );
  },

  addProperty: function() {
    this.setState({rental_properties: this.state.rental_properties.concat(this.getDefaultProperties())});
  },

  removeProperty: function(index) {
    var arr = this.state.rental_properties;
    arr.splice(index, 1);
    this.setState({rental_properties: arr});
  },

  getPrimaryProperty: function() {
    return {
      address: {},
      property_type: null,
      mortgage_payment: null,
      other_mortgage_payment: null,
      market_value: null,
      financing: null,
      other_financing: null,
      mortgage_insurance: null,
      mortgage_include_escrows: null,
      homeowner_insurance: null,
      property_tax: null,
      hoa_due: null,
      monthly_rent: null
    };
  },

  getDefaultProperties: function() {
    return [{
      address: {},
      property_type: null,
      mortgage_payment: null,
      other_mortgage_payment: null,
      market_value: null,
      financing: null,
      other_financing: null,
      mortgage_insurance: null,
      mortgage_include_escrows: null,
      homeowner_insurance: null,
      property_tax: null,
      hoa_due: null,
      monthly_rent: null
    }];
  },

});

module.exports = FormAssetsAndLiabilities;