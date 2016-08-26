/**
 * Quotes page after user find rate
 */
var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ChartMixin = require("mixins/ChartMixin");
var Filter = require("borrower/loans/rates/Filter");
var HelpMeChoose = require("borrower/loans/rates/HelpMeChoose");
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require("./List");

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
  },

  autoClickFilter: function() {
    $("input[name=30years]")[0].click();
    $(".filter-sidebar input[type=checkbox]:nth(4)").click();

    // if(this.props.bootstrapData.selected_programs) {
    //   switch(this.props.bootstrapData.selected_programs) {
    //     case "30yearFixed":
    //       $("input[name=30years]").trigger("click");
    //       break;
    //     case "15yearFixed":
    //       $("input[name=15years]").trigger("click");
    //       break;
    //     case "5yearARM":
    //       $("input[name=51arm]").trigger("click");
    //       break;
    //   }
    // }
    // else {
    // }
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

    var lender_underwriting_fee_object = rate.fees.find(function(x) { return x.Description == "Lender underwriting fee" });
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
        lender_underwriting_fee: lender_underwriting_fee_object === undefined ? 0 : lender_underwriting_fee_object.FeeAmount,
        appraisal_fee: this.getFee(rate.thirty_fees, "Services you cannot shop for", "Appraisal Fee"),
        tax_certification_fee: this.getFee(rate.thirty_fees, "Services you cannot shop for", "Tax Certification Fee"),
        flood_certification_fee: this.getFee(rate.thirty_fees, "Services you cannot shop for", "Flood Certification Fee"),
        outside_signing_service_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Outside Signing Service"),
        concurrent_loan_charge_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Title - Concurrent Loan Charge"),
        endorsement_charge_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Endorsement Charge"),
        lender_title_policy_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Title - Lender's Title Policy"),
        recording_service_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Title - Recording Service Fee"),
        settlement_agent_fee: this.getFee(rate.thirty_fees, "Services you can shop for", "Title - Settlement Agent Fee"),
        recording_fees: this.getFee(rate.thirty_fees, "Taxes and other government fees", "Recording Fees"),
        owner_title_policy_fee: this.getFee(rate.thirty_fees, "Other", "Title - Owner's Title Policy"),
        prepaid_item_fee: this.getFee(rate.thirty_fees, "Prepaid items", "Prepaid interest")
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

  getFee: function(arrFees, groupName, objectName){
    var group = arrFees.find(function(x) {
      return x.Description === groupName;
    });

    if (group === undefined){
      return 0;
    }

    var obj = group.Fees.find(function(x) {
      return x.Description.indexOf(objectName) > -1;
    });

    if (obj === undefined){
      return 0;
    }
    else{
      return obj.FeeAmount;
    }
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
                      <HelpMeChoose backToRatePage={this.backToRateHandler} programs={this.props.bootstrapData.quotes} selectRate={this.selectRate} monthlyPayment={this.state.monthlyPayment} isInitialQuotes={true}/>
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
                            <div className="col-xs-5 text-left">
                              <a className="btn btn-filter text-uppercase" data-toggle="modal" data-target="#filterQuotes">Filter</a>
                            </div>
                            <div className="modal fade filter-modal" id="filterQuotes" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                              <div className="modal-dialog modal-sm" role="document">
                                <div className="modal-content">
                                  <div className="modal-header">
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                  </div>
                                  <div className="modal-body">
                                    <Filter programs={this.props.bootstrapData.quotes} storedCriteria={this.onStoredCriteriaChange} onFilterProgram={this.onFilterQuote}></Filter>
                                  </div>
                                  <div className="modal-footer">
                                    <button type="button" className="btn select-btn" data-dismiss="modal">OK</button>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <div className="col-xs-3 text-xs-right text-sm-right">
                              <b>Sort by</b>
                            </div>
                            <div className="col-xs-4 select-box pull-right">
                              <select className="form-control" id="sortRateOptions" onChange={this.handleSortChange}>
                                <option value="apr">APR</option>
                                <option value="pmt">Monthly Payment</option>
                                <option value="rate">Rate</option>
                                <option value="tcc">Total Closing Cost</option>
                              </select>
                              <span>&#9660;</span>
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
                                    <option value="apr">APR</option>
                                    <option value="pmt">Monthly Payment</option>
                                    <option value="rate">Rate</option>
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
                          <List quotes={this.state.quotes} monthlyPayment={this.state.monthlyPayment} selectRate={this.selectRate} helpMeChoose={false}/>
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
