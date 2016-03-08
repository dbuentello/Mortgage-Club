var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var TermTab = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function() {
    return ({});
  },

  render: function() {
    console.log(this.props.loan);
    var loanId = this.props.loan.amount
    var loan = this.props.loan
    return (
      <div className="term-board">
        <h1> Your Final Loan Terms </h1>
        <span> Your Loan Summary: </span>
        <div className="table-responsive">
          <table className="table table-striped term-table">
            <tbody>
              <tr>
                <td>
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
                <td>
                  Property Value
                </td>
                <td>
                  {}
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
                  Initial Draw
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Holdback Amount
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Loan Term
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Interest Rate
                </td>
                <td>
                  {this.props.loan.interest_rate}
                </td>
              </tr>
              <tr>
                <td>
                  Loan Type
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Closing Cost
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Discount Points
                </td>
                <td>
                  {loan.discount_points}
                </td>
              </tr>
              <tr>
                <td>
                  Pre-Payment Pernalty
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Down Payment
                </td>
                <td>
                  {loan.down_payment}
                </td>
              </tr>
              <tr>
                <td>
                  Target Closing Date
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Purpose
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Loan amortization
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Loan amortization
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Loan amortization
                </td>
                <td>
                  {}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    )
  }
});

module.exports = TermTab;