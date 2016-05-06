var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var Form = require("./Form");

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
    // var address = {
    //     id: addressId,
    //     zip: null,
    //     state: null,
    //     city: null,
    //     street_address: null,
    //     street_address2: null,
    //     full_text: null
    //   };
    var fieldLength = this.props.loanWritableAttributes.length;
    var loanFieldState = new Array(fieldLength);
    loanFieldState.fill(false, 0, fieldLength);
    var state;


    state = { editMode: false, loanFieldState: loanFieldState

        }
    return state;
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
    this.setState(change);
  },

  onPropertyChange: function(change) {
    // var property = this.state.property
    this.setState({property: change})
  },


  handleShowFields: function(event) {
    event.preventDefault();
    var selectedIndex = event.target.selectedIndex
    var loanFieldState = this.state.loanFieldState;
    loanFieldState[selectedIndex] = true;
    this.setState({loanFieldState: loanFieldState});
  },


  renderViewTermBoard: function() {
    var loan = this.props.loan;
    var property = this.props.property
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
    var restLoanFields  = this.props.loanWritableAttributes;
    var MakeItem = function(X, index) {
        return <option value={X}>{X}</option>;
    };
    debugger

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
              <Form loan={this.props.loan} address={this.props.address}  property_id={this.props.property.id} address_id={this.props.address.id} property={this.props.property} loanWritableAttributes={this.props.loanWritableAttributes}/>
              :
              this.renderViewTermBoard()
            }

          </div>
        </div>
      );
  }
});

module.exports = LoanTerms