var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var FormProperty = React.createClass({
  getInitialState: function() {
    return {
      property_type: null,
      loan_purpose: null,
      property_purpose: null
    };
  },

  onChange: function(change) {
    if (change.address && change.address.city) {
      this.searchProperty(change.address);
    }

    this.setState(change);
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
              <AddressField label='Property Address' address={this.state.address} keyName='address' editable={true} onChange={this.onChange} placeholder='Please enter the address of the property'/>
              <SelectField label='Property Type' keyName='property_type' value={this.state.property_type} options={propertyTypes} editable={true} onChange={this.onChange} allowBlank={true}/>
              <SelectField label='Purpose of Loan' keyName='loan_purpose' value={this.state.loan_purpose} options={loanPurposes} editable={true} onChange={this.onChange} allowBlank={true}/>
              <SelectField label='Property will be used for' keyName='property_purpose' value={this.state.property_purpose} options={propertyPurposes} editable={true} onChange={this.onChange} allowBlank={true}/>
              {this.state.loan_purpose === null ? null :
                this.state.loan_purpose == 'purchase'
                ? <TextField label='Purchase Price' keyName='purchase_price' value={this.state.purchase_price} editable={true} onChange={this.onChange}/>
                : <div>
                    <TextField label='Original Purchase Price' keyName='original_purchase_price' value={this.state.original_purchase_price} editable={true} onChange={this.onChange}/>
                    <TextField label='What year did you buy your property?' keyName='original_purchase_year' value={this.state.original_purchase_year} placeholder='YYYY' editable={true} onChange={this.onChange}/>
                  </div>
              }
            </div>
            <div className='box text-right'>
              <a className='btn btnSml btnPrimary'>Next</a>
            </div>
          </div>
        </div>
        <div className='helpSection sticky pull-right overlayRight overlayTop'>
        </div>
      </div>
    );
  }
});

module.exports = FormProperty;
