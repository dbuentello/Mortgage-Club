var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var fields = {
  address: {label: 'Property Address', name: 'address', helpText: 'The full address of the subject property for which you are applying for a loan.'},
  propertyType: {label: 'Property Type', name: 'property_type', helpText: 'The type of building classification of the property.'},
  loanPurpose: {label: 'Purpose of Loan', name: 'purpose', helpText: 'The purpose for taking out the loan in terms of how funds will be used.'},
  propertyPurpose: {label: 'Property Will Be', name: 'usage', helpText: 'The primary purpose of acquiring the subject property.'},
  purchasePrice: {label: 'Purchase Price', name: 'purchase_price', helpText: 'How much are you paying for the subject property?'},
  originalPurchasePrice: {label: 'Original Purchase Price', name: 'original_purchase_price', helpText: 'How much did you pay for the subject property?'},
  originalPurchaseYear: {label: 'Purchase Year', name: 'original_purchase_year', helpText: 'The year in which you bought your home.'}
};

var FormProperty = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return this.buildStateFromLoan(this.props.loan);
  },

  onChange: function(change) {
    var address = change.address;
    if (address) {
      this.setState({property: null});
      if (address.city && address.zip && address.state) {
        this.searchProperty(address);
      }
    }

    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  searchProperty: function(address) {
    $.ajax({
      url: '/properties/search',
      data: {
        address: [address.street_address, address.street_address2].join(' '),
        citystatezip: [address.city, address.state, address.zip].join(' ')
      },
      dataType: 'json',
      context: this,
      success: function(response) {
        if (this.state.property_type === null) {
          this.setState({property_type: response.useCode});
        }
        this.setState({property: response});
      }
    });
  },

  render: function() {
    var propertyTypes = [
      {value: 'sfh', name: 'Single Family Home'},
      {value: 'duplex', name: 'Duplex'},
      {value: 'triplex', name: 'Triplex'},
      {value: 'fourplex', name: 'Fourplex'}
    ];

    var loanPurposes = [
      {value: 'purchase', name: 'Purchase'},
      {value: 'refinance', name: 'Refinance'}
    ];

    var propertyPurposes = [
      {value: 'primary_residence', name: 'Primary Residence'},
      {value: 'vacation_home', name: 'Vacation Home'},
      {value: 'rental_property', name: 'Rental Property'}
    ];

    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mtn'>
              <AddressField label={fields.address.label}
                address={this.state[fields.address.name]}
                keyName={fields.address.name}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.address)}
                placeholder=''/>
              <div className='row'>
                <div className="col-sm-6">
                  <SelectField
                    label={fields.propertyType.label}
                    keyName={fields.propertyType.name}
                    value={this.state[fields.propertyType.name]}
                    options={propertyTypes}
                    editable={true}
                    onChange={this.onChange}
                    onFocus={this.onFocus.bind(this, fields.propertyType)}
                    allowBlank={true}/>
                </div>
                <div className="col-sm-6">
                  <SelectField
                    label={fields.propertyPurpose.label}
                    keyName={fields.propertyPurpose.name}
                    value={this.state[fields.propertyPurpose.name]}
                    options={propertyPurposes}
                    editable={true}
                    onChange={this.onChange}
                    onFocus={this.onFocus.bind(this, fields.propertyPurpose)}
                    allowBlank={true}/>
                </div>
              </div>
              <SelectField
                label={fields.loanPurpose.label}
                keyName={fields.loanPurpose.name}
                value={this.state[fields.loanPurpose.name]}
                options={loanPurposes}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.loanPurpose)}
                allowBlank={true}/>
              {this.state[fields.loanPurpose.name] === null ? null :
                this.state[fields.loanPurpose.name] == 'purchase'
                ? <TextField
                    label={fields.purchasePrice.label}
                    keyName={fields.purchasePrice.name}
                    value={this.state[fields.purchasePrice.name]}
                    editable={true}
                    liveFormat={true}
                    format={this.formatCurrency}
                    onFocus={this.onFocus.bind(this, fields.purchasePrice)}
                    onChange={this.onChange}/>
                : <div>
                    <TextField
                      label={fields.originalPurchasePrice.label}
                      keyName={fields.originalPurchasePrice.name}
                      value={this.state[fields.originalPurchasePrice.name]}
                      editable={true}
                      liveFormat={true}
                      format={this.formatCurrency}
                      onFocus={this.onFocus.bind(this, fields.originalPurchasePrice)}
                      onChange={this.onChange}/>
                    <TextField
                      label={fields.originalPurchaseYear.label}
                      keyName={fields.originalPurchaseYear.name}
                      value={this.state[fields.originalPurchaseYear.name]}
                      placeholder='YYYY'
                      editable={true}
                      onFocus={this.onFocus.bind(this, fields.originalPurchaseYear)}
                      onChange={this.onChange}/>
                  </div>
              }
            </div>
            <div className='box text-right'>
              <a className='btn btnSml btnPrimary' onClick={this.save} disabled={this.state.saving}>
                {this.state.saving ? 'Saving' : 'Save and Continue'}<i className='icon iconRight mls'/>
              </a>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField
          ? <div>
              <span className='typeEmphasize'>
                <i className="iconInfo typeFacebook"></i>
                &nbsp;
                {this.state.focusedField.label}
              </span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
        </div>
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(_.extend(this.buildStateFromLoan(nextProps.loan), {
      saving: false
    }));
  },

  buildStateFromLoan: function(loan) {
    var property = loan.property;
    var state = {};

    state[fields.loanPurpose.name] = loan[fields.loanPurpose.name];
    state[fields.address.name] = property[fields.address.name];
    state[fields.propertyType.name] = property[fields.propertyType.name];
    state[fields.propertyPurpose.name] = property[fields.propertyPurpose.name];
    state[fields.purchasePrice.name] = this.formatCurrency(property[fields.purchasePrice.name]);
    state[fields.originalPurchasePrice.name] = this.formatCurrency(property[fields.originalPurchasePrice.name]);
    state[fields.originalPurchaseYear.name] = property[fields.originalPurchaseYear.name];

    return state;
  },

  buildLoanFromState: function() {
    var loan = {};
    loan[fields.loanPurpose.name] = this.state[fields.loanPurpose.name];
    loan.property_attributes = {id: this.props.loan.property.id};
    loan.property_attributes[fields.propertyType.name] = this.state[fields.propertyType.name];
    loan.property_attributes[fields.propertyPurpose.name] = this.state[fields.propertyPurpose.name];
    loan.property_attributes[fields.purchasePrice.name] = this.currencyToNumber(this.state[fields.purchasePrice.name]);
    loan.property_attributes[fields.originalPurchasePrice.name] = this.currencyToNumber(this.state[fields.originalPurchasePrice.name]);
    loan.property_attributes[fields.originalPurchaseYear.name] = this.state[fields.originalPurchaseYear.name];
    loan.property_attributes.address_attributes = this.state.address;
    loan.property_attributes.zpid = this.state.property ? this.state.property.zpid : null;
    return loan;
  },

  save: function() {
    this.setState({saving: true});
    this.props.saveLoan(this.buildLoanFromState(), 0);
  }
});

module.exports = FormProperty;
