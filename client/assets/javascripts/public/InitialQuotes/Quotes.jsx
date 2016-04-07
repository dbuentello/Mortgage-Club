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
      monthlyPayment: this.props.bootstrapData.monthly_payment
    }
  },
  componentDidMount: function(){
      mixpanel.track("Quotes-Enter");
      $("input[name=30years]").trigger("click");
  },
  onFilterQuote: function(filteredQuotes) {
    this.removeChart();
    this.setState({quotes: filteredQuotes})
  },

  handleSortChange: function(event) {
    this.removeChart();
    var option = $("#sortRateOptions").val();
    var sortedRates = this.sortBy(option, this.state.quotes);
    this.setState({quotes: sortedRates});
  },

  removeChart: function(){
    $(".line-chart").empty();
    $(".pie-chart").empty();
    $("span.glyphicon-menu-up").click();
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
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  backToRateHandler: function() {
    this.setState({helpMeChoose: false});
  },

  selectRate: function(rate) {
    mixpanel.track("Quotes-SelectRate");

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
                    <div className="content container mortgage-quotes white-background" style={{"padding-top":"20px"}}>
                      <HelpMeChoose backToRatePage={this.backToRateHandler} programs={this.props.bootstrapData.quotes} selectRate={this.selectRate} isInitialQuotes={true}/>
                    </div>
                  :
                    <div className="content container mortgage-rates row-eq-height padding-top-0 row">
                      <div className="col-xs-3 subnav">
                        <Filter programs={this.props.bootstrapData.quotes} onFilterProgram={this.onFilterQuote}></Filter>
                      </div>
                      <div className="col-xs-9 account-content padding-left-50">
                        <div className="row actions">
                          <p>
                            We’ve found {this.state.quotes ? this.state.quotes.length : 0} mortgage options for you. You can sort, filter and choose one on your own or click
                            <i> Help me choose </i>
                            and our proprietary selection algorithm will help you choose the best mortgage.
                          </p>
                          <p>{"Mortgage rates change frequently. We're showing the latest rates for your mortgage scenario."}</p>
                          <div className="row form-group actions-group" id="mortgageActions">
                            <div className="col-md-6">
                              <div className="row">
                                <div className="col-xs-2">
                                  <label>Sort by</label>
                                </div>
                                <div className="col-xs-8 select-box">
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
                              <a className="btn choose-btn text-uppercase" onClick={this.helpMeChoose}>help me choose</a>
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
              <div className="not-found">
                <h2>{"We're sorry, there aren't any quotes matching your needs."}</h2>
                <div className="row">
                  <button className="btn btn-mc col-md-offset-5" onClick={this.backToQuotesForm}>Back</button>
                </div>
              </div>
          }
        </div>
      </div>
    );
  }
});

module.exports = Quotes;
