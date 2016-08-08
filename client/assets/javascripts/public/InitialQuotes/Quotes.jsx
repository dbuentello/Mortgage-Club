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
      code_id: this.props.bootstrapData.code_id

    }
  },

  componentDidMount: function() {
    mixpanel.track("Quotes-Enter");
    this.autoClickFilter();
  },

  autoClickFilter: function() {
    if(this.props.bootstrapData.selected_programs) {
      switch(this.props.bootstrapData.selected_programs) {
        case "30yearFixed":
          $("input[name=30years]").trigger("click");
          break;
        case "15yearFixed":
          $("input[name=15years]").trigger("click");
          break;
        case "5yearARM":
          $("input[name=51arm]").trigger("click");
          break;
      }
    }
    else {
      $("input[name=30years]").trigger("click");
    }
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
        property_type: dataCookies.property_type
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
                      <div className="col-xs-12 col-md-3 subnav hidden-xs programs-filter">
                        <Filter rate_alert={this.state.rate_alert} code_id={this.state.code_id} programs={this.props.bootstrapData.quotes} storedCriteria={this.onStoredCriteriaChange} onFilterProgram={this.onFilterQuote}></Filter>
                      </div>
                      <div className="col-xs-12 col-sm-9 account-content">
                        <div className="mobile-xs-quote">
                          <div className="visible-xs text-xs-justify">
                            <p>
                              We’ve found {this.state.quotes ? this.state.quotes.length : 0} loan programs for you. You can sort, filter and choose one to <i>Apply Now</i> or click <i>HELP ME CHOOSE</i> and our proprietary algorithm will help you choose the best mortgage.
                            </p>
                            <p>
                              Mortgage rates change frequently. We’re showing the latest rates for your mortgage scenario.
                            </p>
                          </div>
                          <div className="row form-group visible-xs">
                            <div className="col-xs-12 text-left text-xs-center">
                              <a className="btn text-uppercase help-me-choose-btn" onClick={this.helpMeChoose}>help me choose</a>
                            </div>
                            <div className="col-xs-5 text-left">
                              <a className="btn btn-filter text-uppercase" data-toggle="modal" data-target="#filterQuotes">Filter</a>
                            </div>
                            <div className="modal fade" id="filterQuotes" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
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
                            <div className="col-xs-3 text-xs-right">
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
                        <div className="row actions hidden-xs">
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
