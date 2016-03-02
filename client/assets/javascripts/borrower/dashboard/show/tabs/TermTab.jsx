var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var TermTab = React.createClass({
  mixins: [TextFormatMixin],
  render: function() {
    return (
      <div className="term-board">
        <h1> Your Final Loan Terms </h1>
        <span> Your Loan Summary: <span>
        <div className="table-responsive">
          <table className="table table-striped term-table">
            <tbody>
              <tr>
                <td>
                  Property Address
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Borrower Name
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Guarantor Name
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
                  {}
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
                  {}
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
                  Amortization
                </td>
                <td>
                  {}
                </td>
              </tr>
              <tr>
                <td>
                  Origination Fee
                </td>
                <td>
                  {}
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