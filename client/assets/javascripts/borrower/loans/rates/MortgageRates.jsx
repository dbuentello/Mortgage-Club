var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require('./List');
var HelpMeChoose = require('./HelpMeChoose');
var Filter = require('./Filter');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      programs: this.props.bootstrapData.programs,
      helpMeChoose: false,
      signDoc: false,
      selectedRate: null,
      storedCriteria: []
    }
  },

  selectRate: function(rate) {
    this.setState({
      signDoc: true,
      selectedRate: rate
    });
    var params = {};
    params["rate"] = rate;
    params = $.param(params);
    location.href = "esigning/" + this.props.bootstrapData.currentLoan.id + "?" + params;
  },

  helpMeChoose: function() {
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  onStoredCriteriaChange: function(criteria) {
    var currentCriteria = this.props.storedCriteria;
    this.setState({storedCriteria: criteria});
  },

  handleSortChange: function(event) {
    var option = $("#sortRateOptions").val();
    var sortedRates = this.sortBy(option, this.state.programs);
    this.setState({programs: sortedRates});
  },

  onFilterProgram: function(filteredPrograms) {
    this.removeChart();
    this.setState({programs: filteredPrograms})
  },

  backToRateHandler: function() {
    this.setState({helpMeChoose: false});
  },

  removeChart: function(){
    $(".line-chart").empty();
    $(".pie-chart").empty();
    $("span.glyphicon-menu-up").click();
  },

  componentDidMount: function() {
    $("input[name=30years]").trigger("click");
  },

  render: function() {
    // don't want to make ugly code
    var guaranteeMessage = "We're showing the best 3 loan options for you";
    var subjectProperty = this.props.bootstrapData.currentLoan.subject_property;

    return (
      <div>
        {
          this.state.helpMeChoose
          ?
            <div className="content container mortgage-rates padding-top-0 white-background">
              <HelpMeChoose backToRatePage={this.backToRateHandler} loan={this.props.bootstrapData.currentLoan} programs={this.props.bootstrapData.programs} selectRate={this.selectRate} isInitialQuotes={false}/>
            </div>
          :
            <div className="content container mortgage-rates padding-top-0 row-eq-height">
              <div className="col-xs-3 subnav programs-filter">
                <Filter programs={this.props.bootstrapData.programs} storedCriteria={this.onStoredCriteriaChange} onFilterProgram={this.onFilterProgram}></Filter>
              </div>
              <div className="col-xs-12 col-sm-9 account-content padding-left-50">
                <div className="row actions">
                  <p>
                    We’ve found {this.state.programs ? this.state.programs.length : 0} loan programs for you. You can sort, filter and choose one on your own or click <i>HELP ME CHOOSE</i> and our proprietary algorithm will help you choose the best mortgage.
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
                      <a className="btn choose-btn text-uppercase" onClick={this.helpMeChoose}>help me choose</a>
                    </div>
                  </div>
                </div>
                <div id="mortgagePrograms">
                  <List loanAmount={this.props.bootstrapData.currentLoan.amount} programs={this.state.programs} subjectProperty={subjectProperty} selectRate={this.selectRate} helpMeChoose={false}/>
                </div>
              </div>
            </div>
        }
      </div>
    );
  },

  sortBy: function(field, programs) {
    this.removeChart();
    var sortedRates = [];
    switch(field) {
      case "apr":
        sortedRates = _.sortBy(programs, function (rate) {
          return parseFloat(rate.apr);
        });
        break;
      case "pmt":
        sortedRates = _.sortBy(programs, function (rate) {
          return parseFloat(rate.monthly_payment);
        });
        break;
      case "rate":
        sortedRates = _.sortBy(programs, function (rate) {
          return parseFloat(rate.interest_rate);
        });
        break;
      case "tcc":
        sortedRates = _.sortBy(programs, function (rate) {
          return parseFloat(rate.total_closing_cost);
        });
        break;
    }

    return sortedRates;
  }
});

module.exports = MortgageRates;