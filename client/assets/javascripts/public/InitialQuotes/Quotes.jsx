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
      quotes: this.props.quotes
    }
  },

  onFilterQuote: function(filteredQuotes) {
    this.setState({quotes: filteredQuotes})
  },

  handleSortChange: function(event) {
    var option = $("#sortRateOptions").val();
    var sortedRates = this.sortBy(option, this.state.quotes);
    this.setState({quotes: sortedRates});
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
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  backToRateHandler: function() {
    this.setState({helpMeChoose: false});
  },

  choosePossibleRates: function(periods, avgRate, taxRate) {
    var totalCost = 0;
    var result;
    var possibleRates = _.sortBy(this.state.quotes, function (rate) {
      result = this.totalCost(rate, taxRate, avgRate, periods);
      rate["total_cost"] = result["totalCost"];
      rate["result"] = result;
      return rate["total_cost"];
    }.bind(this));

    possibleRates = possibleRates.slice(0, 1);

    this.setState({
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      helpMeChoose: true
    });
  },

  selectRate: function(rate) {
    $.ajax({
      url: "/initial_quotes/save_info",
      data: {
        zip_code: this.props.zipCode,
        credit_score: this.props.creditScore,
        mortgage_purpose: this.props.mortgagePurpose,
        property_value: this.props.propertyValue,
        property_usage: this.props.propertyUsage,
        property_type: this.props.propertyType
      },
      method: "POST",
      dataType: "json",
      success: function(response) {
        if(this.props.currentUser.id) {
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
      <div className="quotes-list">
        {
          this.props.quotes.length > 0
          ?
            <div>
              {
                this.state.helpMeChoose
                ?
                  <div className="content container mortgage-rates padding-top-0 white-background">
                    <HelpMeChoose backToRatePage={this.backToRateHandler} programs={this.state.quotes} selectRate={this.selectRate} isInitialQuotes={true}/>
                  </div>
                :
                  <div className="content container mortgage-rates padding-top-0 row">
                    <div className="col-xs-3 subnav programs-filter">
                      <Filter programs={this.props.quotes} onFilterProgram={this.onFilterProgram}></Filter>
                    </div>
                    <div className="col-xs-9 account-content padding-left-50">
                      <div className="row actions">
                        <p>
                          We’ve found {this.props.quotes ? this.props.quotes.length : 0} mortgage options for you. You can sort, filter, and choose one on your own or click
                          <i> Help me choose </i>
                          and our proprietary selection algorithm will help you choose the best mortgage. No fees no costs option is also included in
                          <i> Help me choose </i>.
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
                            <a className="btn choose-btn text-uppercase" onClick={this.helpMeChoose}>help me choose</a>
                          </div>
                        </div>
                      </div>
                      <div id="mortgagePrograms">
                        <List quotes={this.state.quotes} selectRate={this.selectRate} displayTotalCost={false}/>
                      </div>
                    </div>
                  </div>
              }
            </div>
          :
            <div className="not-found">
              <h2>{"We're sorry, there aren't any quotes matching your needs."}</h2>
              <div className="row">
                <button className="btn theBtn col-md-offset-5" onClick={this.backToQuotesForm}>Back</button>
              </div>
            </div>
        }
      </div>
    );
  }
});

module.exports = Quotes;
