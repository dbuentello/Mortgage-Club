var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var HelpTooltip = require('components/form/HelpTooltip');
var BooleanRadio = require('components/form/BooleanRadio');

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

var FormAssetsAndLiabilities = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};

    _.each(fields, function (field) {
      state[field.name] = null;
    });

    state.rental_properties = this.getDefaultProperties();
    state.primary_property = this.getDefaultPrimaryProperty();

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
      <div key={index} className={'box mtn mbm pam bas roundedCorners' + (index % 2 === 0 ? ' backgroundLowlight' : '')}>
        <div className='row'>
          <div className='col-xs-6'>
            <AddressField
              label='Address'
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
              label='Monthly rent'
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
  },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn'>
              <h5 className='typeDeemphasize'>Your primary residence</h5>
              <div className='box mtn mbm pam bas roundedCorners'>
                <div className='row'>
                  <div className='col-xs-6'>
                    <AddressField
                      label='Address'
                      address={this.state.primary_property.address}
                      keyName={'primary_property.address'}
                      editable={true}
                      onChange={this.onChange}
                      placeholder='Please select from one of the drop-down options'/>
                  </div>
                  <div className='col-xs-3'>
                    <SelectField
                      label='Property Type'
                      keyName={'primary_property.property_type'}
                      value={this.state.primary_property.property_type}
                      options={propertyTypes}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label='Estimated Market Value'
                      keyName={'primary_property.market_value'}
                      value={this.state.primary_property.market_value}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-6'>
                    <SelectField
                      label='Mortgage Payment'
                      keyName={'primary_property.mortgage_payment'}
                      value={this.state.primary_property.mortgage_payment}
                      options={mortgagePayments}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}/>
                  </div>
                  { this.state.primary_property.mortgage_payment == "Other"
                    ? <div className='col-xs-6'>
                        <TextField
                          label='Other'
                          keyName={'primary_property.other_mortgage_payment'}
                          value={this.state.primary_property.other_mortgage_payment}
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
                      keyName={'primary_property.financing'}
                      value={this.state.primary_property.financing}
                      options={otherFinancings}
                      editable={true}
                      onChange={this.onChange}
                      allowBlank={true}/>
                  </div>
                  { this.state.primary_property.financing == "Other"
                    ? <div className='col-xs-6'>
                        <TextField
                          label='Other'
                          keyName={'primary_property.other_financing'}
                          value={this.state.primary_property.other_financing}
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
                      keyName={'primary_property.mortgage_insurance'}
                      value={this.state.primary_property.mortgage_insurance}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-6'>
                    <SelectField
                      label='Does your mortgage payment include escrows?'
                      keyName={'primary_property.mortgage_include_escrows'}
                      value={this.state.primary_property.mortgage_include_escrows}
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
                      keyName={'primary_property.homeowner_insurance'}
                      value={this.state.primary_property.homeowner_insurance}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3'>
                    <TextField
                      label='Property Tax'
                      keyName={'primary_property.property_tax'}
                      value={this.state.primary_property.property_tax}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                  <div className='col-xs-3 pln'>
                    <TextField
                      label='HOA Due (if applicable)'
                      keyName={'primary_property.hoa_due'}
                      value={this.state.primary_property.hoa_due}
                      editable={true}
                      onChange={this.onChange}/>
                  </div>
                </div>
                <div className='row'>
                  <div className='col-xs-6'>
                  <TextField
                    label='Monthly rent'
                    keyName={'primary_property.monthly_rent'}
                    value={this.state.primary_property.monthly_rent}
                    editable={true}
                    onChange={this.onChange}/>
                </div>
                </div>
              </div>
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
              <br/>
              {this.state.focusedField.helpText}
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

  getDefaultPrimaryProperty: function() {
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

module.exports = FormAssetsAndLiabilities;