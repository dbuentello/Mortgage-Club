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

    state.own_investment_property = this.props.loan.own_investment_property;
    state.rental_properties = this.props.loan.rental_properties;
    state.primary_property = this.props.loan.primary_property;
    state.saving = false;
    return state;
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
              <Property property={this.state.primary_property} />
            </div>
          </div>

          <div className='pal'>
            <div className='box mvn'>
              <h5 className='typeDeemphasize'>Do you own investment property?</h5>
              <BooleanRadio
                label=''
                checked={this.state.own_investment_property}
                keyName={"own_investment_property"}
                editable={true}
                onChange={this.onChange}/>
            </div>

            {this.state.own_investment_property ?
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
    };
  },

  save: function() {
    this.setState({saving: true});

    var primary_property = this.state.primary_property;
    primary_property.address_attributes = primary_property.address;

    var rental_properties = [];
    for (var i = 0; i < this.state.rental_properties.length; i++) {
      var rental_property = this.state.rental_properties[i];
      rental_property.address_attributes = rental_property.address;
      rental_properties.push(rental_property);
    }

    $.ajax({
      url: '/properties/',
      method: 'POST',
      context: this,
      dataType: 'json',
      data: {
        loan_id: this.props.loan.id,
        primary_property: primary_property,
        rental_properties: rental_properties,
        own_investment_property: this.state.own_investment_property
      },
      success: function(response) {
        this.props.setupMenu(response, 4);
        this.setState({saving: false});
      },
      error: function(response, status, error) {
        alert(error);
        this.setState({saving: false});
      }
    });
  }

});

module.exports = FormAssetsAndLiabilities;