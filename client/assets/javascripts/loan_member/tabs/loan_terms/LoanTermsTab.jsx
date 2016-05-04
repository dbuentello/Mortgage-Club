var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var TextField = require("components/Form/TextField");
var AddressField = require("components/Form/NewAddressField");
function getFormattedAddress(addressable) {
  if (!addressable) {
    return 'Unknown';
  }

  var address = _.compact([
    addressable.street_address,
    addressable.street_address2,
    addressable.city,
    addressable.state
  ]).join(', ');

  if(address && addressable.zip) {
    address += " " + addressable.zip;
    return address;
  }
  else {
    return addressable.full_text;
  }


  return (!address) ? addressable.full_text : address;
}

var LoanTerms = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    var loan = this.props.loan;
    var property = loan.subject_property;
    var addressId = this.props.address ? this.props.address.id : null;
    var address = {
        id: addressId,
        zip: null,
        state: null,
        city: null,
        street_address: null,
        street_address2: null,
        full_text: null
      };

    var fieldLength = this.props.loanWritableAttributes.length;
    var loanFieldState = new Array(fieldLength);
    loanFieldState.fill(false, 0, fieldLength);

    return {
      editMode: false,
      loanFieldState: loanFieldState,
      loan: loan,
      property: property,
      address: (this.props.address || address)
    };
  },

  listeners: [],

  componentFields: {
    street_number: 'short_name',
    route: 'long_name',
    locality: 'long_name',
    administrative_area_level_1: 'short_name',
    country: 'long_name',
    postal_code: 'short_name'
  },

  initAutocomplete: function(el) {
    if (typeof google == 'undefined') {
      return;
    }

    // Create the autocomplete object, restricting the search
    // to geographical location types.
    var autocomplete = new google.maps.places.Autocomplete(el, {
      types: ['geocode'],
      componentRestrictions: {country: 'us'}
    });

    this.listeners.push(google.maps.event.addListener(autocomplete, 'place_changed', function() {

      var place = autocomplete.getPlace();
      var address = {
          value: el.value
        },
        change = {},
        addressType, i, val;

      // prevent error Uncaught TypeError
      if (typeof place.address_components == 'undefined') {
        return;
      }

      // Get each component of the address from the place details
      // and set the corresponding field in the state.
      for (i = 0; i < place.address_components.length; i++) {
        addressType = place.address_components[i].types[0];

        if (this.componentFields[addressType]) {
          val = place.address_components[i][this.componentFields[addressType]];
          address[addressType] = val;
        }
      }

      if (address.street_number && address.route) {
        address.street_address = address.street_number + ' ' + address.route;
      } else {
        address.street_address = el.value.split(',')[0];
      }

      change["address"] = _.extend(this.props.address || {}, {
        street_address: address.street_address,
        street_address2: '',
        city: address.locality,
        state: address.administrative_area_level_1,
        zip: address.postal_code,
        full_text: el.value
      });
      this.setState({address: {
        id: this.state.address.id,
        street_address: address.street_address,
        street_address2: '',
        city: address.locality,
        state: address.administrative_area_level_1,
        zip: address.postal_code,
        full_text: el.value
      }})
    }));

    this.listeners.push(google.maps.event.addDomListener(el, 'keydown', function (e) {
      if (e.keyCode == 13) {
        // google.maps.event.trigger(this.autocomplete, 'place_changed');

        if (e.preventDefault) {
          e.preventDefault();
        } else {
          e.cancelBubble = true;
          e.returnValue = false;
        }
      }
    }));
  },

  componentDidMount: function() {
    var placeInput = document.getElementById('property_address');
    this.initAutocomplete(placeInput);
  },


  componentWillUnmount: function() {
    _.each(this.listeners, function (listener) {
      google.maps.event.removeListener(listener);
    });
    document.body.removeEventListener('click', this.handleClickAway);
  },

  componentDidUpdate: function() {
    var placeInput = document.getElementById('property_address');
    this.initAutocomplete(placeInput);
  },

  calculateMonthlyHousingExpense: function(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue) {
    var expense = 0.0;
    if(parseFloat(hoaDue))
    {
      expense += parseFloat(hoaDue);
    }

    if(parseFloat(mortgageInsurance))
    {
      expense += parseFloat(mortgageInsurance);
    }

    expense += parseFloat(monthlyPayment);
    expense += parseFloat(homeOwnerInsurance);
    expense += parseFloat(propertyTax);
    return expense;
  },

  handleEditLoan: function() {
    this.setState({editMode: true});
  },

  onChange: function(change) {
    this.setState({loan: change});
  },

  onPropertyChange: function(change) {
    // var property = this.state.property
    this.setState({property: change})
  },

  onAddressChange: function(change) {
    this.setState({address: change})
  },


  handleShowFields: function(event) {
    event.preventDefault();
    var selectedIndex = event.target.selectedIndex
    var loanFieldState = this.state.loanFieldState;
    loanFieldState[selectedIndex] = true;
    this.setState({loanFieldState: loanFieldState});
  },

  renderLoanTermForm: function() {
    var loan = this.state.loan;
    var property = this.state.property;

    var propertyTax = property.estimated_property_tax;
    var homeOwnerInsurance = property.estimated_hazard_insurance;
    var monthlyPayment = loan.monthly_payment;
    var hoaDue = property.hoa_due
    var mortgageInsurance = property.estimated_mortgage_insurance;
    var totalCost = this.calculateMonthlyHousingExpense(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue);
    var restLoanFields  = this.props.loanWritableAttributes;
    var MakeItem = function(X, index) {
        return <option value={X}>{X}</option>;
    };

    var RenderLoanField = function(X) {
      return (

          <div className='form-group'>
            <div className='col-sm-4'>
              <TextField
                label={X}
                keyName={X}
                name={"loan[" + X + "]"}
                value={this.state.loan[X] ? this.state.loan[X] : null}
                onChange={this.onChange}
                editable={true}/>
            </div>
          </div>

      );
    }.bind(this);

    return (
    <div>
      <form className="form-horizontal loan_term_form">
        <div className='form-group'>
          <input type="hidden" name="property[id]" value={this.props.property.id}/>

          <div className="col-sm-8">
            <label className="col-xs-12 pan">

              <span className='h7 typeBold'>Property Address</span>
              <input type="text" className="address-input" id="property_address"  onChange={this.onAddressChange} value={this.state.address.full_text} name="address[full_text]" />

            </label>

            <input type="hidden" name="address[id]" value={this.state.address.id}/>
            <input type="hidden" name="address[zip]" value={this.state.address.zip}/>
            <input type="hidden" name="address[city]" value={this.state.address.city}/>
            <input type="hidden" name="address[street_address]" value={this.state.address.street_address}/>
            <input type="hidden" name="address[street_address2]" value={this.state.address.street_address2}/>
            <input type="hidden" name="address[state]" value={this.state.address.state}/>
          </div>
        </div>
        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Property Value'
              keyName='property_value'
              name='property[market_price]'
              value={this.state.property.market_price}
              onChange={this.onPropertyChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Loan Amount'
              keyName='amount'
              name='loan[amount]'
              value={this.state.loan.amount}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Loan Type'
              keyName='amortization_type'
              name='loan[amortization_type]'
              value={this.state.loan.amortization_type}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Interest Rate'
              keyName='interest_rate'
              name='loan[interest_rate]'
              value={this.state.loan.interest_rate}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Lender Credits'
              keyName='lender_credits'
              name='loan[lender_credits]'
              value={this.state.loan.lender_credits}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Lender Fees'
              keyName='loan_costs'
              name='loan[loan_costs]'
              value={this.state.loan.loan_costs}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Third Party Services'
              keyName='third_party_fees'
              name='loan[third_party_fees]'
              value={this.state.loan.third_party_fees}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Prepaid Items'
              keyName='estimated_prepaid_items'
              name='loan[estimated_prepaid_items]'
              value={this.state.loan.estimated_prepaid_items}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Down payment'
              keyName='down_payment'
              name='loan[down_payment]'
              value={this.state.loan.down_payment}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Total Cost to Close'
              keyName='estimated_cash_to_close'
              name='loan[estimated_cash_to_close]'
              value={this.state.loan.estimated_cash_to_close}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>


        <div className="row">
          <h4 className="terms-4-loan-members"> Housing Expense</h4>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Principal and Interest'
              keyName='monthly_payment'
              name='loan[monthly_payment]'
              value={this.state.loan.monthly_payment}
              onChange={this.onChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Homeowners Insurance'
              keyName='estimated_hazard_insurance'
              name='property[estimated_hazard_insurance]'
              value={this.state.property.estimated_hazard_insurance}
              onChange={this.onPropertyChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Property Tax'
              keyName='estimated_property_tax'
              name='property[estimated_property_tax]'
              value={this.state.property.estimated_property_tax}
              onChange={this.onPropertyChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Mortgage Insurance'
              keyName='estimated_mortgage_insurance'
              name='property[estimated_mortgage_insurance]'
              value={this.state.property.estimated_mortgage_insurance}
              onChange={this.onPropertyChange}
              editable={true}/>
          </div>
        </div>

        <div className='form-group'>
          <div className='col-sm-4'>
            <TextField
              label='Hoa DUE'
              keyName='hoa_due'
              name='property[hoa_due]'
              value={this.state.property.hoa_due}
              onChange={this.onPropertyChange}
              editable={true}/>
          </div>
        </div>
        {
          _.map(restLoanFields, function(X, index) {
            if(this.state.loanFieldState[index] === true){
              return RenderLoanField(X)
            }
          }.bind(this))
        }
        <div className="row">
          <div className='col-sm-4'>
            <select onChange={this.handleShowFields}>{restLoanFields.map(MakeItem)}</select>
          </div>

        </div>
        <div className="row">
          <div className="col-md-12">
            <button className="btn btn-primary pull-right" id="submit_form" onClick={this.handleSubmitForm}>Save</button>
          </div>
        </div>
        </form>
      </div>
      )
  },

  handleSubmitForm: function(event) {
    event.preventDefault();
    $.ajax({
      url: "/loan_members/loans/"+this.props.loan.id+"/update_loan_terms",
      method: "PUT",
      dataType: "json",
      data: $('.loan_term_form').serialize(),
      success: function(data) {
        this.setState({editMode: false, loan: data.loan, property: data.property, address: data.address})
      }.bind(this),
      error: function(errorCode){
        console.log(errorCode);
      }

    });


  },

  renderViewTermBoard: function() {
    var loan = this.state.loan;
    var property = this.state.property
    var propertyTax = property.estimated_property_tax;
    var homeOwnerInsurance = property.estimated_hazard_insurance;
    var monthlyPayment = loan.monthly_payment;
    var hoaDue = property.hoa_due
    var mortgageInsurance = property.estimated_mortgage_insurance;
    var totalCost = this.calculateMonthlyHousingExpense(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue);
    var addressFullText = getFormattedAddress(this.props.address) || "Unknown Address";
    return ( <div>
              <div className="table-responsive term-board">
                <table className="table table-striped term-table">
                  <tbody>
                    <tr>
                      <td className="loan-field">
                        Property Address
                      </td>
                      <td>
                        { addressFullText }
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Property Value
                      </td>
                      <td>
                        {
                          property.market_price
                          ?
                          this.formatCurrency(property.market_price, "$")
                          :
                          null
                        }
                      </td>
                    </tr>
                    <tr>
                      <td>
                        Loan Amount
                      </td>
                      <td>
                        {loan.amount ? this.formatCurrency(loan.amount,"$") : null}
                      </td>
                    </tr>
                    <tr>
                      <td>
                        Loan Type
                      </td>
                      <td>
                        {loan.amortization_type}
                      </td>
                    </tr>
                    <tr>
                      <td>
                        Interest Rate
                      </td>
                      <td>
                        {loan.interest_rate ? this.commafy(loan.interest_rate*100, 3) : null}%
                      </td>
                    </tr>


                  </tbody>
                </table>

              </div>

              <div className="row">
                <h4 className="terms-4-loan-members"> Closing Cost </h4>
              </div>

              <div className="table-responsive term-board">
                <table className="table table-striped term-table">
                  <tbody>
                    {
                      loan.lender_credits < 0.0
                      ?

                        <tr>
                          <td className="loan-field">
                            Lender Credits
                          </td>
                          <td>
                            {this.formatCurrency(loan.lender_credits, "$")}
                          </td>
                        </tr>

                      :

                        <tr>
                          <td className="loan-field">
                            Discount Points
                          </td>
                          <td>
                            {loan.lender_credits ? this.formatCurrency(loan.lender_credits, "$") : null}
                          </td>
                        </tr>
                    }
                    <tr>
                      <td className="loan-field">
                        Lender Fees
                      </td>
                      <td>
                        {loan.loan_costs ? this.formatCurrency(loan.loan_costs, "$") : null}
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Third Party Services
                      </td>
                      <td>
                        {loan.third_party_fees ? this.formatCurrency(loan.third_party_fees, "$") : null}
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Prepaid Items
                      </td>
                      <td>
                        {loan.estimated_prepaid_items ? this.formatCurrency(loan.estimated_prepaid_items, "$") : null}
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Down Payment
                      </td>
                      <td>
                        {loan.down_payment ? this.formatCurrency(loan.down_payment, "$") : null}
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        <i>Total Cash to Close (est.)</i>
                      </td>
                      <td>
                        <i>{loan.estimated_cash_to_close ? this.formatCurrency(loan.estimated_cash_to_close, "$") : null}</i>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div className="row">
                <h4 className="terms-4-loan-members"> Housing Expense</h4>
              </div>

              <div className="table-responsive term-board">
                <table className="table table-striped term-table">
                  <tbody>
                    <tr>
                      <td className="loan-field">
                        Principal and Interest
                      </td>
                      <td>
                        {loan.monthly_payment ? this.formatCurrency(loan.monthly_payment, "$") : null }
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Homeowners Insurance
                      </td>
                      <td>
                        {this.formatCurrency(property.estimated_hazard_insurance, "$")}
                      </td>
                    </tr>
                    <tr>
                      <td className="loan-field">
                        Property Tax
                      </td>
                      <td>
                        {property.estimated_property_tax ? this.formatCurrency(property.estimated_property_tax, "$") : null}
                      </td>
                    </tr>
                    {
                      property.estimated_mortgage_insurance>0.0
                      ?
                      <tr>
                        <td>
                          Mortgage Insurance
                        </td>
                        <td>
                          {this.formatCurrency(property.estimated_mortgage_insurance, "$")}
                        </td>
                      </tr>
                      :
                      null
                    }
                    {
                      ((property.hoa_due > 0.0) && (property.hoa_due !== 0.0))
                      ?
                      <tr>
                        <td>
                          HOA Due
                        </td>
                        <td>
                          {property.hoa_due ? this.formatCurrency(property.hoa_due,"$") : null}
                        </td>
                      </tr>
                      :
                      null
                    }
                    <tr>
                      <td>
                        <i>Total Monthly Housing Expense (est.)</i>
                      </td>
                      <td>
                        <i>{this.formatCurrency(totalCost, "$")}</i>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>);
  },


  render: function() {
    var loan = this.props.loan;
    var property = loan.subject_property;
    var propertyTax = property.estimated_property_tax;
    var homeOwnerInsurance = property.estimated_hazard_insurance;
    var monthlyPayment = loan.monthly_payment;
    var hoaDue = property.hoa_due
    var mortgageInsurance = property.estimated_mortgage_insurance;
    var totalCost = this.calculateMonthlyHousingExpense(monthlyPayment, homeOwnerInsurance, propertyTax, mortgageInsurance, hoaDue);
    return (
        <div className="panel panel-flat terms-view">
          <div>
            <div className="row">
              <div className="col-md-7 pull-left">
                <h4 className="loan-summary"> Your Loan Summary </h4>
              </div>
              <div className="col-md-5">
                <span className="pull-right"><i className="icon-pencil7" onClick={this.handleEditLoan}/></span>
              </div>
            </div>


            {
              this.state.editMode === true
              ?
              this.renderLoanTermForm()
              :
              this.renderViewTermBoard()
            }

          </div>
        </div>
      );
  }
});

module.exports = LoanTerms