/**
 * Quotes page after user find rate
 */
var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ChartMixin = require("mixins/ChartMixin");
var Filter = require("borrower/loans/rates/Filter");
var RateAlert = require("borrower/loans/rates/RateAlert");
var HelpMeChoose = require("borrower/loans/rates/HelpMeChoose");
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require("./List");

var mobile_alert_fields = {
  firstName: {label: "First name", name: "mobile_first_name", keyName: "mobile_first_name", error: "mobileFirstNameError",validationTypes: "empty"},
  lastName: {label: "Last name", name: "mobile_last_name", keyName: "mobile_last_name", error: "mobileLastNameError",validationTypes: "empty"},
  email: {label: "Email", name: "mobile_email", keyName: "mobile_email", error: "mobileEmailError", validationTypes: "email"}
};

var Quotes = React.createClass({
  mixins: [TextFormatMixin, ChartMixin, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      helpMeChoose: false,
      quotes: this.props.bootstrapData.quotes,
      monthlyPayment: this.props.bootstrapData.monthly_payment,
      storedCriteria: [],
      rate_alert: true,
      code_id: this.props.bootstrapData.code_id,
      dataCookies: this.props.bootstrapData.data_cookies
    }
  },

  componentDidMount: function() {
    mixpanel.track("Quotes-Enter");
    this.autoClickFilter();
    $("body").removeClass("device-lg");
  },

  autoClickFilter: function() {
    $("input[name=30years]")[0].click();
    $(".filter-sidebar input[type=checkbox]:nth(4)").click();
  },

  onFilterQuote: function(filteredQuotes) {
    this.removeChart();
    this.setState({quotes: filteredQuotes});
  },

  onStoredCriteriaChange: function(criteria) {
    var currentCriteria = this.props.storedCriteria;
    this.setState({storedCriteria: criteria});
  },

  handleSortChange: function(event) {
    this.removeChart();
    var sortedRates = this.sortBy(event.target.value, this.state.quotes);
    this.setState({quotes: sortedRates});
  },

  removeChart: function(){
    $(".line-chart").empty();
    $(".pie-chart").empty();
    $("span.fa-angle-up").click();
  },
  sortBy: function(field, quotes) {
    var sortedRates = [];

    switch(field) {
      case "apr":
        sortedRates = _.sortBy(quotes, function (rate) {
          return parseFloat(rate.apr);
        });
        break;
      case "pmt":
        sortedRates = _.sortBy(quotes, function (rate) {
          return parseFloat(rate.monthly_payment);
        });
        break;
      case "rate":
        sortedRates = _.sortBy(quotes, function (rate) {
          return parseFloat(rate.interest_rate);
        });
        break;
      case "tcc":
        sortedRates = _.sortBy(quotes, function (rate) {
          return parseFloat(rate.total_closing_cost);
        });
        break;
    }

    return sortedRates;
  },

  helpMeChoose: function() {
    mixpanel.track("Quotes-HelpMeChoose");
    this.setState({helpMeChoose: !this.state.helpMeChoose,
    });
  },

  backToRateHandler: function() {
    mixpanel.track("Quotes-HelpMeChoose-BackToResults");
    this.setState({helpMeChoose: false});
  },

  selectRate: function(rate) {
    if(this.state.helpMeChoose){
      mixpanel.track("Quotes-HelpMeChoose-SelectRate");
    }else{
      mixpanel.track("Quotes-SelectRate");
    }
    var dataCookies = this.props.bootstrapData.data_cookies;
    var cash_out = rate.loan_amount - (parseFloat(dataCookies.mortgage_balance) || 0);
    $.ajax({
      url: "/quotes/save_info",
      data: {
        zip_code: dataCookies.zip_code,
        credit_score: dataCookies.credit_score,
        down_payment: dataCookies.down_payment,
        mortgage_balance: dataCookies.mortgage_balance,
        mortgage_purpose: dataCookies.mortgage_purpose,
        property_value: dataCookies.property_value,
        property_usage: dataCookies.property_usage,
        property_type: dataCookies.property_type,
        loan_amount: rate.loan_amount,
        lender_name: rate.lender_name,
        amortization_type: rate.product,
        interest_rate: rate.interest_rate,
        period: rate.period,
        total_closing_cost: rate.total_closing_cost,
        lender_credits: rate.lender_credits,
        monthly_payment: rate.monthly_payment,
        loan_type: rate.loan_type,
        apr: rate.apr,
        lender_nmls_id: rate.nmls,
        pmi_monthly_premium_amount: rate.pmi_monthly_premium_amount,
        discount_pts: rate.discount_pts,
        lender_underwriting_fee: rate.lender_underwriting_fee,
        appraisal_fee: this.getFee(rate.thirty_fees, "Appraisal Fee"),
        tax_certification_fee: this.getFee(rate.thirty_fees, "Tax Certification Fee"),
        flood_certification_fee: this.getFee(rate.thirty_fees, "Flood Certification Fee"),
        outside_signing_service_fee: this.getFee(rate.thirty_fees, "Outside Signing Service"),
        concurrent_loan_charge_fee: this.getFee(rate.thirty_fees, "Title - Concurrent Loan Charge"),
        endorsement_charge_fee: this.getFee(rate.thirty_fees, "Endorsement Charge"),
        lender_title_policy_fee: this.getFee(rate.thirty_fees, "Title - Lender's Title Policy"),
        recording_service_fee: this.getFee(rate.thirty_fees, "Title - Recording Service Fee"),
        settlement_agent_fee: this.getFee(rate.thirty_fees, "Title - Settlement Agent Fee"),
        recording_fees: this.getFee(rate.thirty_fees, "Recording Fees"),
        owner_title_policy_fee: this.getFee(rate.thirty_fees, "Title - Owner's Title Policy"),
        prepaid_item_fee: this.getFee(rate.prepaid_fees, "Prepaid interest"),
        prepaid_homeowners_insurance: this.getFee(rate.prepaid_fees, "Prepaid homeowners insurance for 12 months"),
        cash_out: cash_out
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        if(this.props.bootstrapData.currentUser.id) {
          this.createLoan();
        }
        else {
          location.href = "/auth/register/signup";
        }
      }.bind(this)
    });
  },

  getFee: function(arrFees, objectName){
    var object = arrFees.find(function(x) {
      return x.Description.indexOf(objectName) > -1;
    });

    if (object === undefined){
      return 0;
    }

    return object.FeeAmount;
  },

  backToQuotesForm: function() {
    location.href = "/quotes";
  },

  createLoan: function() {
    $.ajax({
      url: "/loans",
      method: "POST",
      dataType: "json",
      success: function(response) {
        location.href = "/loans/" + response.loan_id + "/edit";
      },
      error: function(response, status, error) {
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div className="initial-quotes">
        <div className="quotes-list">
          {
            this.props.bootstrapData.quotes.length > 0
            ?
              <div>
                {
                  this.state.helpMeChoose
                  ?
                    <div className="content container mortgage-quotes padding-top-0 white-background">
                      <HelpMeChoose backToRatePage={this.backToRateHandler} programs={this.props.bootstrapData.quotes} selectRate={this.selectRate} monthlyPayment={this.state.monthlyPayment} isInitialQuotes={true} loanPurpose={this.props.bootstrapData.data_cookies.mortgage_purpose} mortgageBalance={this.props.bootstrapData.data_cookies.mortgage_balance}/>
                    </div>
                  :
                    <div className="content container mortgage-rates padding-top-0 row-eq-height">
                      <div className="col-sm-12 col-md-3 subnav hidden-xs hidden-sm programs-filter">
                        <Filter rate_alert={this.state.rate_alert} code_id={this.state.code_id} programs={this.props.bootstrapData.quotes} storedCriteria={this.onStoredCriteriaChange} onFilterProgram={this.onFilterQuote} dataCookies={this.state.dataCookies}></Filter>
                      </div>
                      <div className="col-sm-12 col-md-9 account-content">
                        <div className="mobile-xs-quote">
                          <div className="visible-xs visible-sm text-xs-justify text-sm-justify">
                            <p>
                              We’ve found {this.state.quotes ? this.state.quotes.length : 0} loan programs for you. You can sort, filter and choose one to <i>Apply Now</i> or click <i>HELP ME CHOOSE</i> and our proprietary algorithm will help you choose the best mortgage.
                            </p>
                            <p>
                              Mortgage rates change frequently. We’re showing the latest rates for your mortgage scenario.
                            </p>
                          </div>
                          <div className="row form-group visible-xs visible-sm">
                            <div className="col-xs-12 text-left text-xs-center text-sm-center">
                              <a className="btn text-uppercase help-me-choose-btn" onClick={this.helpMeChoose}>help me choose</a>
                            </div>
                          </div>
                          <div className="row form-group menu-rates visible-sm visible-xs">
                            <ul>
                              <li>
                                <a href="" data-toggle="modal" data-target="#email_alert2">
                                  <span className="fa fa-bell-o" aria-hidden="true"></span>
                                </a>
                              </li>
                              <li>
                                <a href="" data-toggle="modal" data-target="#filterQuotes">
                                  <span className="fa fa-filter" aria-hidden="true" ></span>
                                </a>
                              </li>
                              <li>
                                <a>
                                  <span className="fa fa-sort" aria-hidden="true"></span>
                                </a>
                                <select id="mobileSortRateOptions" onChange={this.handleSortChange} style={{"opacity": "0", "marginTop": "-50px", "width": "100%", "height": "50px"}}>
                                  <option value="rate">Rate</option>
                                  <option value="apr">APR</option>
                                  <option value="pmt">Monthly Payment</option>
                                  <option value="tcc">Total Closing Cost</option>
                                </select>
                              </li>
                            </ul>
                            <RateAlert code_id={this.state.code_id} fields={mobile_alert_fields} index={2}/>
                            <div className="modal fade filter-modal" id="filterQuotes" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                              <div className="modal-dialog modal-md" role="document">
                                <div className="modal-content">
                                  <div className="modal-header">
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                  </div>
                                  <div className="modal-body">
                                    <Filter programs={this.props.bootstrapData.quotes} storedCriteria={this.onStoredCriteriaChange} onFilterProgram={this.onFilterQuote} dataCookies={this.state.dataCookies}></Filter>
                                  </div>
                                  <div className="modal-footer">
                                    <button type="button" className="btn select-btn" data-dismiss="modal">OK</button>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div className="row actions hidden-xs hidden-sm">
                          <p>
                            We’ve found {this.state.quotes ? this.state.quotes.length : 0} loan programs for you. You can sort, filter and choose one to <i>Apply Now</i> or click <i>HELP ME CHOOSE</i> and our proprietary algorithm will help you choose the best mortgage.
                          </p>
                          <p>
                            Mortgage rates change frequently. We’re showing the latest rates for your mortgage scenario.
                          </p>
                          <div className="row form-group actions-group" id="mortgageActions">
                            <div className="col-md-6">
                              <div className="row">
                                <div className="col-xs-3">
                                  <label>Sort by</label>
                                </div>
                                <div className="col-xs-9 select-box">
                                  <select className="form-control" id="sortRateOptions" onChange={this.handleSortChange}>
                                    <option value="rate">Rate</option>
                                    <option value="apr">APR</option>
                                    <option value="pmt">Monthly Payment</option>
                                    <option value="tcc">Total Closing Cost</option>
                                  </select>
                                  <img className="dropdownArrow" src="/icons/dropdownArrow.png" alt="arrow"/>
                                </div>
                              </div>
                            </div>
                            <div className="col-md-6 text-right">
                              <a className="btn choose-btn text-uppercase" id="helpmechoose-md" onClick={this.helpMeChoose}>help me choose</a>
                            </div>
                          </div>
                        </div>
                        <div id="mortgagePrograms">
                          <List quotes={this.state.quotes} userRole={this.props.bootstrapData.user_role} monthlyPayment={this.state.monthlyPayment} codeId={this.state.code_id} selectRate={this.selectRate} helpMeChoose={false}/>
                        </div>
                      </div>
                    </div>
                }
              </div>
            :
              <div className="not-found text-center" style={{"marginTop": "150px"}}>
                <h2>{"Sorry, we can't find any loan programs for your scenario! :("}</h2>
                <div className="row btnSubmit">
                  <button className="btn btn-mc" onClick={this.backToQuotesForm}>Go back</button>
                </div>
              </div>
          }
        </div>
      </div>
    );
  }
});

module.exports = Quotes;
