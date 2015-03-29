var _ = require('lodash');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');

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
  mixins: [ObjectHelperMixin],

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
    this.setState(this.setValue(this.state, _.keys(change)[0], _.values(change)[0]));
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
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
                            keyName={'rental_properties[' + index + '].market_value'}
                            value={property.market_value}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                        <div className='col-xs-6'>
                          <TextField
                            label='Estimated Tax & Insurance'
                            keyName={'rental_properties[' + index + '].tax_and_insurance'}
                            value={property.tax_and_insurance}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                      </div>
                      <div className='row'>
                        <div className='col-xs-6'>
                          <TextField
                            label='Rental Income'
                            keyName={'rental_properties[' + index + '].rental_income'}
                            value={property.rental_income}
                            editable={true}
                            onChange={this.onChange}/>
                        </div>
                        <div className='row col-xs-6 man pan'>
                          <div className='col-xs-8'>
                            <BooleanRadio
                              label='Is this property an impound?'
                              checked={property.is_impound}
                              keyName={'rental_properties[' + index + '].is_impound'}
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
      address: null,
      property_type: null,
      market_value: null,
      tax_and_insurance: null,
      rental_income: null,
      is_impound: null
    }];
  }
});

module.exports = FormRealEstates;
