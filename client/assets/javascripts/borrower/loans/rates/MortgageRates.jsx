var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require('./List');
var HelpMeChoose = require('./HelpMeChoose');
var sortedRates;

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates,
      helpMeChoose: false
    }
  },

  onSelect: function(rate) {
    console.dir(rate['fees'])
    // location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
  },

  chooseBestRates: function(periods, avgRate, taxRate) {
    var totalCost = 0;
    sortedRates = this.state.rates;
    sortedRates = _.sortBy(this.state.rates, function (rate) {
      totalCost = this.totalCost(rate, taxRate, avgRate, periods);
      rate['total_cost'] = totalCost;
      console.dir(totalCost);
      return totalCost;
    }.bind(this));
    // sortedRates = sortedRates.slice(0, 10);

    this.setState({
      helpMeChoose: true
    });
  },

  render: function() {
    return (
      <div className='content container mortgage-rates'>
        <HelpMeChoose chooseBestRates={this.chooseBestRates}/>
        <div className='row mtl'>
          <div className='col-sm-6'>
            <span className='typeLowlight'>Sort by:</span>
            <a className='clickable mlm' onClick={_.bind(this.sortBy, null, 'apr')}>APR</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'pmt')}>Monthly Payment</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'rate')}>Rate</a>
          </div>
          <div className='col-sm-6 text-right'>
            <a className='btn btnSml btnAction'>Help me choose</a>
          </div>
        </div>
        {this.state.helpMeChoose ?
          <List rates={sortedRates}/>
        :
          <List rates={this.state.rates}/>
        }
      </div>
    );
  },

  sortBy: function(field) {
    if (field == 'apr') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.apr);
      })});
    } else if (field == 'pmt') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.monthly_payment);
      })});
    } else if (field == 'rate') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.interest_rate);
      })});
    }
  }
});

module.exports = MortgageRates;
