var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var MortgageDataTable = require("./MortgageDataTable");
var SearchBox = require("./SearchBox");

var MortgageDataRecord = React.createClass({
  mixins: [TextFormatMixin],
  handleGoBack: function() {
    window.history.back();
  },

  render: function() {
    var record = this.props.bootstrapData.mortgage_data_record;
    return (
      <div>
        {/* Page header */ }
        <div className="page-header">
          <div className="page-header-content">
            <div className="page-title">
              <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Mortgage Data </span> - Management</h4>
            </div>
          </div>
        </div>
        {/* /page header */ }

        {/* Page container */ }
        <div className="page-container">

          {/* Page content */ }
          <div className="page-content">

            {/* Main content */ }
            <div className="content-wrapper">

              {/* Table */ }
              <div className="panel panel-flat">
                <div className="panel-body">
                  <div class="row">
                    <button className="btn btn-primary pull-right back-btn" onClick={this.handleGoBack}><i className="icon-circle-left2 position-left"></i>
                      Back
                    </button>
                  </div>
                  <h3> Original Loan Information </h3>
                  <dl className="dl-horizontal">
                    <dt>Property Address:</dt>
                    <dd>{record.property_address}</dd>
                    <dt> First Owner Name:</dt>
                    <dd>{record.owner_name_1}</dd>
                    <dt> Second Owner Name:</dt>
                    <dd>{record.owner_name_2}</dd>
                    <dt> Original Purchase Price:</dt>
                    <dd>{this.formatCurrency(record.original_purchase_price, "$")}</dd>
                    <dt>Original Loan Amount:</dt>
                    <dd>{this.formatCurrency(record.original_loan_amount, "$")}</dd>
                    <dt> Original Terms:</dt>
                    <dd>{record.original_terms}</dd>
                    <dt> Original Lock-in Date:</dt>
                    <dd>{record.original_lock_in_date}</dd>
                    <dt> Average Rate at Lock-in Date:</dt>
                    <dd>{record.avg_rate_at_lock_in_date}</dd>
                    <dt> Original Lender Name:</dt>
                    <dd>{record.original_lender_name}</dd>
                    <dt> Original Lender Average Overlay:</dt>
                    <dd>{record.original_lender_average_overlay}</dd>
                    <dt> Original Estimated Rate:</dt>
                    <dd>{this.commafy(record.original_estimated_interest_rate*100, 3)}%</dd>
                    <dt> Date of Proposal:</dt>
                    <dd>{record.date_of_proposal}</dd>
                    <dt> Original Estimated Mortgage Balance:</dt>
                    <dd>{this.formatCurrency(record.original_estimated_mortgage_balance, "$")}</dd>
                    <dt> Original Monthly Payment:</dt>
                    <dd>{this.formatCurrency(record.original_monthly_payment, "$")}</dd>
                    <dt> Original Estimated Home Value:</dt>
                    <dd>{this.formatCurrency(record.original_estimated_home_value, "$")}</dd>
                  </dl>

                  <h3 className="text-center"> Lower Rate </h3>
                  <dl className="dl-horizontal">
                    <dt> New Loan Amount:</dt>
                    <dd>{record.lower_rate_loan_amount}</dd>
                    <dt> New Interest Rate:</dt>
                    <dd>{record.lower_rate_interest_rate}</dd>
                    <dt> New Loan Start Date:</dt>
                    <dd>{record.lower_rate_loan_start_date}</dd>
                    <dt> Estimated Closing Costs:</dt>
                    <dd>{record.lower_rate_estimated_closing_costs}</dd>
                    <dt> Lender Credit:</dt>
                    <dd>{record.lower_rate_lender_credit}</dd>
                    <dt> Net Closing Costs:</dt>
                    <dd>{record.lower_rate_net_closing_costs}</dd>
                    <dt> New Monthly Payment:</dt>
                    <dd>{record.lower_rate_new_monthly_payment}</dd>
                    <dt> Savings in 1 Year:</dt>
                    <dd>{record.lower_rate_savings_1year}</dd>
                    <dt> Savings in 3 Years:</dt>
                    <dd>{record.lower_rate_savings_3year}</dd>
                    <dt> Savings in 10 Years:</dt>
                    <dd>{record.lower_rate_savings_10year}</dd>
                  </dl>
                  <h3> Cash Out </h3>
                  <dl className="dl-horizontal">
                    <dt> LTV:</dt>
                    <dd>{record.cash_out_ltv}</dd>
                    <dt> New Loan Amount:</dt>
                    <dd>{record.cash_out_loan_amount}</dd>
                    <dt> New Interest Rate:</dt>
                    <dd>{record.cash_out_interest_rate}</dd>
                    <dt> New Loan Start Date:</dt>
                    <dd>{record.cash_out_loan_start_date}</dd>
                    <dt> Estimated Closing Costs:</dt>
                    <dd>{record.cash_out_estimated_closing_costs}</dd>
                    <dt> Lender Credit:</dt>
                    <dd>{record.cash_out_lender_credit}</dd>
                    <dt> Net Closing Costs:</dt>
                    <dd>{record.cash_out_net_closing_costs}</dd>
                    <dt> New Monthly Payment:</dt>
                    <dd>{record.cash_out_new_monthly_payment}</dd>

                  </dl>
                </div>
              </div>
              {/* /table */ }

            </div>
            {/* /main content */ }

          </div>
          {/* /page content */ }

        </div>
        {/* /page container */ }
      </div>
    );
  }
});

module.exports = MortgageDataRecord;
