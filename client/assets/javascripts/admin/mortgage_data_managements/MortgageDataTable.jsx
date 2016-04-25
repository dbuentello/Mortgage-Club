var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var PaginationSection = require("components/PaginationSection");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    return (
      <div>
        <div className="table-responsive">
            <table className="table table-striped table-hover">
              <thead>

                <tr>
                  <th>Property Address</th>
                  <th>Owner</th>
                  <th> Owner Name 2 </th>
                  <th>Original Purchase Price</th>
                  <th>Original Loan Amount</th>
                  <th>Original Loan Date</th>
                  <th>Original Term</th>
                  <th>Lender</th>
                  <th>Original Interest Rate (est.)</th>
                  <th> </th>

                </tr>
              </thead>
              <tbody>
                 {
                    _.map(this.props.MortgageData, function(mortgageDataRecord){
                      return (
                        <tr>
                          <td><a href={"/mortgage_data/" + mortgageDataRecord.id}>{mortgageDataRecord.property_address}</a></td>
                          <td>{mortgageDataRecord.owner_name_2}</td>
                          <td>{mortgageDataRecord.owner_name_1} </td>
                          <td>{mortgageDataRecord.original_purchase_price}</td>
                          <td>{mortgageDataRecord.original_loan_amount}</td>
                          <td>{mortgageDataRecord.original_loan_date}</td>
                          <td>{mortgageDataRecord.original_terms}</td>
                          <td>{mortgageDataRecord.original_lender_name}</td>
                          <td>{mortgageDataRecord.original_estimated_interest_rate}</td>
                          <td><a className="btn btn-primary btn-sm member-title-action" href={"/mortgage_data/" + mortgageDataRecord.id}>More...</a>
                           </td>
                      </tr>
                      )
                    }, this)
                  }
              </tbody>
            </table>
        </div>
        <PaginationSection items={this.props.MortgageData} totalPages={this.props.totalPages} currentPage={this.props.currentPage} />
      </div>
    );
  }
});

module.exports = Borrowers;
