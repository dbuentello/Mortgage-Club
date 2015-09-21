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

    state.rental_properties = this.props.loan.property;
    return state;
  },

  onChange: function(change) {
    var key = _.keys(change)[0];
    var value = _.values(change)[0];
    this.setState(this.setValue(this.state, key, value));

    if (change.owns_rental == true && this.state.rental_properties.length == 1) {
      this.addProperty();
    }
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  eachProperty: function(property, index) {
    if(index == 0) {
      return;
    }
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
              <Property property={this.state.rental_properties[0]} isPrimary={true} />
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

          <div className='box text-right'>
            <a className='btn btnSml btnPrimary' onClick={this.save} disabled={this.state.saving}>
              {this.state.saving ? 'Saving' : 'Save and Continue'}<i className='icon iconRight mls'/>
            </a>
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

  getDefaultProperties: function() {
    return [{
      address: {},
      property_type: null,
      mortgage_payment: null,
      other_mortgage_payment: null,
      market_price: null,
      financing: null,
      other_financing: null,
      mortgage_includes_escrows: null,
      estimated_mortgage_insurance: null,
      estimated_hazard_insurance: null,
      estimated_property_tax: null,
      hoa_due: null,
      gross_rental_income: null
    }];
  },

});

module.exports = FormAssetsAndLiabilities;