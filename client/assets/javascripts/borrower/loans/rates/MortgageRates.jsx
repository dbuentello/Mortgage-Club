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
      rates: this.props.bootstrapData.programs,
      possibleRates: null,
      bestRate: null,
      helpMeChoose: false,
      signDoc: false,
      selectedRate: null
    }
  },

  choosePossibleRates: function(periods, avgRate, taxRate) {
    var totalCost = 0;
    var result;
    var possibleRates = _.sortBy(this.state.rates, function (rate) {
      result = this.totalCost(rate, taxRate, avgRate, periods);
      rate['total_cost'] = result['totalCost'];
      rate['result'] = result;
      return rate['total_cost'];
    }.bind(this));

    possibleRates = possibleRates.slice(0, 3);

    this.setState({
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      helpMeChoose: true
    });
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

  handleSortChange: function(event) {
    this.sortBy($("#sortRateOptions").val());
  },

  onFilterProgram: function(filteredPrograms) {
    this.setState({rates: filteredPrograms})
  },

  render: function() {
    // don't want to make ugly code
    var guaranteeMessage = "We're showing the best 3 loan options for you";
    var subjectProperty = this.props.bootstrapData.currentLoan.subject_property;

    return (
      <div className="content">
        <div className='content container mortgage-rates'>
          <Filter programs={this.props.bootstrapData.rates} onFilterProgram={this.onFilterProgram}></Filter>
          <div className="col-xs-8 account-content">
            <p>
              We’ve found 829 mortgage options for you. You can sort, filter, and choose one on your own or click
              <span className="italic-light">Help me choose</span>
              and our proprietary selection algorithm will help you choose the best mortgage. No fees no costs option is also included in
              <span className="italic-light">Help me choose</span>.
            </p>
            <div className="row form-group" id="mortgageActions">
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
                    </select>
                    <img className="dropdownArrow" src="/icons/dropdownArrow.png" alt="arrow"/>
                  </div>
                </div>
              </div>
              <div className="col-md-6 text-right">
                <a className="btn choose-btn text-uppercase" onClick={this.helpMeChoose}>help me choose</a>
              </div>
            </div>
            <div id="mortgagePrograms">
              { this.state.helpMeChoose
                ?
                  <List rates={this.state.possibleRates} subjectProperty={subjectProperty} selectRate={this.selectRate} displayTotalCost={true}/>
                :
                  <List programs={this.state.rates} subjectProperty={subjectProperty} selectRate={this.selectRate} displayTotalCost={false}/>
              }

            </div>
          </div>



          { this.state.helpMeChoose
            ?
              <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate} selectRate={this.selectRate}/>
            :
            null
          }
          <div className='row mtl'>
            { this.state.helpMeChoose
              ?
                <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate} selectRate={this.selectRate}/>
              :
              null
            }
          </div>
        </div>
      </div>
    );
  },

  sortBy: function(field) {
    if (field == 'apr') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.apr);
      });
    } else if (field == 'pmt') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.monthly_payment);
      });
    } else if (field == 'rate') {
      var sortedRates = _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.interest_rate);
      });
    }

    // console.dir(this.state.helpMeChoose);
    this.setState({rates: sortedRates});
  }
});

module.exports = MortgageRates;
