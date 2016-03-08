var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var TermTab = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function() {
    return ({});
  },

  render: function() {
    var loanId = this.props.loan.amount
    var loan = this.props.loan
    return (
      <div className="panel panel-flat">
        <div>
          <div className="row">
            <h4> Your Loan Summary </h4>
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
                    {this.formatCurrency(this.props.loan.amount,"$")}
                  </td>
                </tr>
                <tr>
                  <td>
                    Loan Type
                  </td>
                  <td>
                    {this.props.loan.loan_type}
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
                <tr>
                  <td>
                    Closing Cost
                  </td>
                  <td>
                    {}
                  </td>
                </tr>

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
                <tr>
                  <td>
                    Mortgage Insurance
                  </td>
                  <td>
                    {this.formatCurrency(loan.primary_property.estimated_mortgage_insurance, "$")}
                  </td>
                </tr>
                <tr>
                  <td>
                    HOA Due
                  </td>
                  <td>
                    {this.formatCurrency(loan.primary_property.hoa_due,"$")}
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