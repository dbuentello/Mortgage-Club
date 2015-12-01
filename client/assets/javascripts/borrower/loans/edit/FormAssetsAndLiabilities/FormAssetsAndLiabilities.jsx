var _ = require('lodash');

var React = require('react/addons');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var BooleanRadio = require('components/form/BooleanRadio');
var Property = require('./Property');
var Asset = require('./Asset');

var SelectedLiabilityArr = [];

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

    state.liabilities = _.sortBy(this.props.bootstrapData.liabilities, function (lib) {
      return parseFloat(lib.payment);
    });

    state.own_investment_property = this.props.loan.own_investment_property;
    state.rental_properties = this.props.loan.rental_properties;
    state.primary_property = this.props.loan.primary_property;
    state.subject_property = this.props.loan.subject_property;
    state.saving = false;
    state.assets = this.props.loan.borrower.assets;

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
        liabilities = {this.state.liabilities}
        isShowRemove={this.state.rental_properties.length > 1}
        onRemove={this.removeProperty}/>
    );
  },

  eachAsset: function(asset, index) {
    return (
      <Asset asset={asset}
             index={index}
             key={asset.id}
             onRemove={this.removeAsset}/>
    );
  },
  // keepTrackOfSelectedLiabilities: function(unselectedLiability, selectedLiability) {
  //   var liabilities = [];
  //   _.remove(SelectedLiabilityArr, function(liabilityID) { return liabilityID == unselectedLiability; });
  //   if (selectedLiability) {
  //     SelectedLiabilityArr.push(selectedLiability);
  //   }

  //   _.each(this.props.bootstrapData.liabilities, function (liability) {
  //     if (SelectedLiabilityArr.indexOf(liability.id) <= -1) {
  //       liabilities.push(liability);
  //     }
  //   });

  //   console.dir(liabilities);
  //   this.setState({liabilities: liabilities});
  // },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn'>
              <h5 className='typeDeemphasize'>Your financial assets</h5>
              {this.state.assets.map(this.eachAsset)}
              <div>
                <a className='btn btnSml btnAction phm' onClick={this.addAsset}>
                  <i className='icon iconPlus mrxs'/> Add Asset
                </a>
              </div>
            </div>
          </div>
          {
            this.state.subject_property
            ?
              <div className='pal'>
                <div className='box mvn'>
                  <h5 className='typeDeemphasize'>The property you're buying</h5>
                  <Property
                    property={this.state.subject_property}
                    liabilities={this.state.liabilities}/>
                </div>
              </div>
            :
              null
          }
          {
            (this.state.primary_property && this.state.primary_property != this.state.subject_property)
            ?
              <div className='pal'>
                <div className='box mvn'>
                  <h5 className='typeDeemphasize'>Your primary residence</h5>
                  <Property
                    property={this.state.primary_property}
                    liabilities={this.state.liabilities}/>
                </div>
              </div>
            :
              null
          }
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
      other_mortgage_payment: null,
      market_price: null,
      financing: null,
      mortgage_includes_escrows: null,
      estimated_mortgage_insurance: null,
      estimated_hazard_insurance: null,
      estimated_property_tax: null,
      hoa_due: null,
      gross_rental_income: null
    };
  },

  addAsset: function(){
    this.setState({assets: this.state.assets.concat(this.getDefaultAsset())});
  },

  removeAsset: function(index){
    var _assets = this.state.assets;
    _assets.splice(index, 1);
    this.setState({assets: _assets});
  },

  getDefaultAsset: function(){
    return {
      institution_name: null,
      asset_type: null,
      current_balance: null
    }
  },

  save: function() {
    this.setState({saving: true});

    var primary_property = this.state.primary_property;
    if (primary_property){
      primary_property.address_attributes = primary_property.address;
    }

    var subject_property = this.state.subject_property;
    if (subject_property){
      subject_property.address_attributes = subject_property.address;
    }

    var rental_properties = [];
    for (var i = 0; i < this.state.rental_properties.length; i++) {
      var rental_property = this.state.rental_properties[i];
      rental_property.address_attributes = rental_property.address;
      rental_properties.push(rental_property);
    }

    $.ajax({
      url: '/borrowers/' + this.props.loan.borrower.id + '/assets',
      method: 'POST',
      context: this,
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({assets: this.state.assets}),
      success: function(resp){
        $.ajax({
          url: '/properties/',
          method: 'POST',
          context: this,
          dataType: 'json',
          data: {
            loan_id: this.props.loan.id,
            primary_property: primary_property,
            subject_property: subject_property,
            rental_properties: rental_properties,
            own_investment_property: this.state.own_investment_property
          },
          success: function(response) {
            this.props.setupMenu(response, 5);
            this.props.bootstrapData.liabilities = response.liabilities;
            // this.setState({saving: false});
          },
          error: function(response, status, error) {
            alert(response.responseJSON.message);
            // this.setState({saving: false});
          }
        });
      }
    });
  }
});

module.exports = FormAssetsAndLiabilities;