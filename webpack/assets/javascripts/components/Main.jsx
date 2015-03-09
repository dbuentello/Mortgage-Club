var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');

var Main = React.createClass({
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
    var user = this.props.bootstrapData.currentUser;
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
        <nav className='backgroundDarkBlue pvl'>
          <div className='container'>
            <div className='row'>
              <div className='col-md-6 typeLowlight'>
                Homieo Logo
              </div>
              <div className='col-md-6 text-right'>
                {user
                ? <span>
                    <span className='typeLowlight mrm'>Hello {user.firstName}!</span>
                    <a className='linkTypeReversed' href='/logout'>Log out</a>
                  </span>
                : <span>
                    <a className='linkTypeReversed mrm' href='/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/signup'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>
        <div className='container pvl'>
          <div>
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
        <div>
          <a className='btn btnSml btnPrimary'>Next</a>
        </div>
        </div>
      </div>
    );
  }
});

module.exports = Main;
