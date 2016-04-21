var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var Borrowers = React.createClass({
  mixins: [TextFormatMixin],

  getInitialState: function() {
    return {

    }
  },



  render: function() {
    return (
      <div>
        <div className="table-responsive">
            <table className="table table-striped table-hover">
              <thead>

                <tr>
                  <th>Address</th>
                  <th>Owner</th>
                  <th> Owner Name 2 </th>
                  <th>Original Purchase Price</th>
                  <th>Original Loan Amount</th>
                  <th>Original Loan Date</th>
                  <th>Original Term</th>
                  <th>Original Lock-in Date</th>
                  <th>Average Rate at Lock-in Date</th>
                  <th>Lender</th>
                  <th>Lender Average Overlay</th>
                  <th>Original Interest Rate (est.)</th>
                  <th>Date of proposal</th>
                  <th>Current Mortgage Balance (est.)</th>
                  <th>Current Monthly Payment</th>
                  <th>Current Home Value (est.)</th>
                  <th>New Loan Amount</th>
                  <th>New Interest Rate</th>
                  <th>Estimated Closing Costs</th>
                  <th>Lender Credit </th>
                  <th>Net Closing Costs</th>
                  <th> New Monthly Payment</th>
                  <th> Savings in 1 year</th>
                  <th>Savings in 3 years </th>
                  <th>Savings in 10 years </th>
                  <th>LTV </th>
                  <th>New Loan Amount </th>
                  <th>Cash Out </th>
                  <th>New Interest Rate </th>
                  <th>Estimated Closing Costs </th>
                  <th>Lender Credit </th>
                  <th>Net Closing Costs </th>
                  <th>New Monthly Payment </th>
                  <th> </th>
                  <th> </th>
                  <th> </th>

                </tr>
              </thead>
              <tbody>
                 {
                    _.map(this.props.MortgageData, function(mortgageDataRecord){
                      return (
                        <tr>
                          <td>{mortgageDataRecord.property_address}</td>
                          <td>{mortgageDataRecord.owner_name_2}</td>
                          <td>{mortgageDataRecord.owner_name_1} </td>
                          <td>{mortgageDataRecord.original_purchase_price}</td>
                          <td>{mortgageDataRecord.original_loan_amount}</td>
                          <td>{mortgageDataRecord.original_loan_date}</td>
                          <td>{mortgageDataRecord.original_terms}</td>
                          <td>{mortgageDataRecord.original_lock_in_date}</td>
                          <td>{mortgageDataRecord.avg_rate_at_lock_in_date}</td>
                          <td>{mortgageDataRecord.original_lender_name}</td>
                          <td>{mortgageDataRecord.original_lender_average_overlay}</td>
                          <td>{mortgageDataRecord.original_estimated_interest_rate}</td>
                          <td>{mortgageDataRecord.date_of_proposal}</td>
                          <td>{mortgageDataRecord.original_estimated_mortgage_balance}</td>
                          <td>{mortgageDataRecord.original_monthly_payment}</td>
                          <td>{mortgageDataRecord.original_estimated_home_value}</td>
                          <td>{mortgageDataRecord.lower_rate_loan_amount}</td>
                          <td>{mortgageDataRecord.lower_rate_interest_rate}</td>
                          <td>{mortgageDataRecord.lower_rate_estimated_closing_costs}</td>
                          <td>{mortgageDataRecord.lower_rate_lender_credit}</td>
                          <td>{mortgageDataRecord.lower_rate_net_closing_costs}</td>
                          <td>{mortgageDataRecord.lower_rate_new_monthly_payment}</td>
                          <td>{mortgageDataRecord.lower_rate_savings_1year}</td>
                          <td>{mortgageDataRecord.lower_rate_savings_3year} </td>
                          <td>{mortgageDataRecord.lower_rate_savings_10year} </td>
                          <td>{mortgageDataRecord.cash_out_ltv}</td>
                          <td>{mortgageDataRecord.cash_out_loan_amount} </td>
                          <td>{mortgageDataRecord.cash_out_cash_amount}</td>
                          <td>{mortgageDataRecord.cash_out_interest_rate} </td>
                          <td>{mortgageDataRecord.cash_out_estimated_closing_costs} </td>
                          <td>{mortgageDataRecord.cash_out_lender_credit} </td>
                          <td>{mortgageDataRecord.cash_out_net_closing_costs}</td>
                          <td>{mortgageDataRecord.cash_out_new_monthly_payment} </td>
                          <td> </td>
                          <td> </td>
                          <td> </td>
                      </tr>
                      )
                    }, this)
                  }

              </tbody>
            </table>
          </div>
      </div>
    );
  }
});

module.exports = Borrowers;
