var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var TermTab = React.createClass({
  mixins: [TextFormatMixin],

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

  render: function() {
    var loan = this.props.loan;
    var property = loan.primary_property;
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
            <h4 className="loan-summary"> Your Loan Summary </h4>
          </div>

          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                <tr>
                  <td className="loan-field">
                    Property Address
                  </td>
                  <td>
                    {
                      this.props.address
                      ?
                      this.props.address
                      :
                      <span>Unknown Address</span>
                    }
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Property Value
                  </td>
                  <td>
                    {
                      loan.subject_property.market_price
                      ?
                      this.formatCurrency(loan.subject_property.market_price, "$")
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
                    {this.formatCurrency(loan.amount,"$")}
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
                    {this.commafy(loan.interest_rate*100, 3)}%
                  </td>
                </tr>


              </tbody>
            </table>

          </div>
          <div className="row">
            <h4>Closing Cost</h4>
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
                        {this.formatCurrency(loan.lender_credits, "$")}
                      </td>
                    </tr>
                }
                <tr>
                  <td className="loan-field">
                    Lender Fees
                  </td>
                  <td>
                    {this.formatCurrency(loan.loan_costs, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Third Party Services
                  </td>
                  <td>
                    {this.formatCurrency(loan.third_party_fees, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Prepaid Items
                  </td>
                  <td>
                    {this.formatCurrency(loan.estimated_prepaid_items, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Down Payment
                  </td>
                  <td>
                    {this.formatCurrency(loan.down_payment, "$")}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div className="row">
            <h4> Housing Expense</h4>
          </div>

          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                <tr>
                  <td className="loan-field">
                    Principal and Interest
                  </td>
                  <td>
                    {this.formatCurrency(loan.monthly_payment, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Homeowners Insurance
                  </td>
                  <td>
                    {this.formatCurrency(loan.primary_property.estimated_hazard_insurance, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Property Tax
                  </td>
                  <td>
                    {this.formatCurrency(loan.primary_property.estimated_property_tax, "$")}
                  </td>
                </tr>
                {
                  loan.primary_property.estimated_mortgage_insurance>0.0
                  ?
                  <tr>
                    <td>
                      Mortgage Insurance
                    </td>
                    <td>
                      {this.formatCurrency(loan.primary_property.estimated_mortgage_insurance, "$")}
                    </td>
                  </tr>
                  :
                  null
                }
                {
                  ((loan.subject_property.hoa_due > 0.0) && (loan.subject_property.hoa_due !== 0.0))
                  ?
                  <tr>
                    <td>
                      HOA Due
                    </td>
                    <td>
                      {this.formatCurrency(loan.primary_property.hoa_due,"$")}
                    </td>
                  </tr>
                  :
                  null
                }
                <tr>
                  <td>
                    Total Monthly Housing Expense (est.)
                  </td>
                  <td>
                    {this.formatCurrency(totalCost, "$")}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

        </div>
      </div>
    )
  }
});

module.exports = TermTab;