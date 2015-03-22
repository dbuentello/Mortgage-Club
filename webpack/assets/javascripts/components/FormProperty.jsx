var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var fields = {
  address: {label: 'Property Address', name: 'address', helpText: 'The full address of the subject property for which you are applying for a loan.'},
  propertyType: {label: 'Property Type', name: 'property_type', helpText: 'The type of building classification of the property.'},
  loanPurpose: {label: 'Purpose of Loan', name: 'loan_purpose', helpText: 'The purpose for taking out the loan in terms of how funds will be used.'},
  propertyPurpose: {label: 'Property Usage', name: 'property_purpose', helpText: 'The primary purpose of acquiring the subject property.'},
  purchasePrice: {label: 'Purchase Price', name: 'purchase_price', helpText: 'How much are you paying for the subject property?'},
  originalPurchasePrice: {label: 'Original Purchase Price', name: 'original_purchase_price', helpText: 'How much did you pay for the subject property?'},
  originalPurchaseYear: {label: 'Purchase Year', name: 'original_purchase_year', helpText: 'The year in which you bought your home.'}
};

var FormProperty = React.createClass({
  getInitialState: function() {
    var state = {};

    _.each(fields, function (field, fieldKey) {
      state[field.name] = null;
    });

    return state;
  },

  onChange: function(change) {
    if (change.address && change.address.city) {
      this.searchProperty(change.address);
    }

    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  searchProperty: function(address) {
    $.ajax({
      url: 'properties/search',
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
      {value: 'Fourplex', name: 'Fourplex'}
    ];

    var loanPurposes = [
      {value: 'purchase', name: 'Purchase'},
      {value: 'refinance', name: 'Refinance'}
    ];

    var propertyPurposes = [
      {value: 'residence', name: 'Primary Residence'},
      {value: 'vacation', name: 'Vacation Home'},
      {value: 'rental', name: 'Rental Property'}
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
                placeholder='Please start entering and select from one of the options in the drop-down menu'/>
              <SelectField
                label={fields.propertyType.label}
                keyName={fields.propertyType.name}
                value={this.state[fields.propertyType.name]}
                options={propertyTypes}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.propertyType)}
                allowBlank={true}/>
              <SelectField
                label={fields.loanPurpose.label}
                keyName={fields.loanPurpose.name}
                value={this.state[fields.loanPurpose.name]}
                options={loanPurposes}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.loanPurpose)}
                allowBlank={true}/>
              <SelectField
                label={fields.propertyPurpose.label}
                keyName={fields.propertyPurpose.name}
                value={this.state[fields.propertyPurpose.name]}
                options={propertyPurposes}
                editable={true}
                onChange={this.onChange}
                onFocus={this.onFocus.bind(this, fields.propertyPurpose)}
                allowBlank={true}/>
              {this.state[fields.loanPurpose.name] === null ? null :
                this.state[fields.loanPurpose.name] == 'purchase'
                ? <TextField
                    label={fields.purchasePrice.label}
                    keyName={fields.purchasePrice.name}
                    value={this.state[fields.purchasePrice.name]}
                    editable={true}
                    onFocus={this.onFocus.bind(this, fields.purchasePrice)}
                    onChange={this.onChange}/>
                : <div>
                    <TextField
                      label={fields.originalPurchasePrice.label}
                      keyName={fields.originalPurchasePrice.name}
                      value={this.state[fields.originalPurchasePrice.name]}
                      editable={true}
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
              <a className='btn btnSml btnPrimary'>Next</a>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
        </div>
      </div>
    );
  }
});

module.exports = FormProperty;
