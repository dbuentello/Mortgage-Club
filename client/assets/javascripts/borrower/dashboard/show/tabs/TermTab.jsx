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
    console.log(this.props.loan.primary_property);
    var loanId = this.props.loan.amount
    var loan = this.props.loan
    return (
      <div className="panel panel-flat">

        <div>
          <h4> Your Final Loan Terms </h4>
          <span> Your Loan Summary: </span>
          <div className="table-responsive term-board">
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
                    Prepaid Items
                  </td>
                  <td>
                    {loan.estimated_prepaid_items}
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
                    Homeowners Insurance
                  </td>
                  <td>
                    {loan.primary_property.estimated_hazard_insurance}
                  </td>
                </tr>
                <tr>
                  <td>
                    Property Tax
                  </td>
                  <td>
                    {loan.primary_property.estimated_property_tax}
                  </td>
                </tr>
                <tr>
                  <td>
                    Mortgage Insurance
                  </td>
                  <td>
                    {loan.primary_property.estimated_mortgage_insurance}
                  </td>
                </tr>
                <tr>
                  <td>
                    HOA Due
                  </td>
                  <td>
                    {loan.primary_property.hoa_due}
                  </td>
                </tr>
                <tr>
                  <td>
                    Mortgage Insurance
                  </td>
                  <td>
                    {loan.estimated_prepaid_items}
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