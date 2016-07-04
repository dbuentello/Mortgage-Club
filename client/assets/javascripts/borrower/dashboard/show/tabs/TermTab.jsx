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
    expense += (parseFloat(homeOwnerInsurance)/12);
    expense += (parseFloat(propertyTax)/12);
    return expense;
  },

  getPropertyValue: function(price) {
    return price ? this.formatCurrency(price, "$") : null;
  },

  isPurchaseLoan: function() {
    return this.props.loan.purpose == "purchase";
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
                      this.isPurchaseLoan()
                      ?
                      this.getPropertyValue(property.purchase_price, "$")
                      :
                      this.getPropertyValue(property.market_price, "$")
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
            <h4>Closing Costs</h4>
          </div>
          <div className="table-responsive term-board">
            <table className="table table-striped term-table">
              <tbody>
                {
                  loan.lender_credits < 0.0
                  ?

                    <tr>
                      <td className="loan-field">
                        Lender Credit
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
                <tr>
                  <td className="loan-field">
                    <i>Total Cash to Close (est.)</i>
                  </td>
                  <td>
                    <i>{this.formatCurrency(loan.estimated_cash_to_close, "$")}</i>
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
                    Annual Homeowners Insurance
                  </td>
                  <td>
                    {this.formatCurrency(property.estimated_hazard_insurance, "$")}
                  </td>
                </tr>
                <tr>
                  <td className="loan-field">
                    Annual Property Tax
                  </td>
                  <td>
                    {this.formatCurrency(property.estimated_property_tax, "$")}
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
                      {this.formatCurrency(property.hoa_due,"$")}
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

        </div>
      </div>
    )
  }
});

module.exports = TermTab;