var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require('./List');
var HelpMeChoose = require('./HelpMeChoose');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates,
      bestRates: null,
      helpMeChoose: false
    }
  },

  onSelect: function(rate) {
    console.dir(rate['fees'])
    // location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
  },

  chooseBestRates: function(periods, avgRate, taxRate) {
    var totalCost = 0;

    var bestRates = _.sortBy(this.state.rates, function (rate) {
      rate['total_cost'] = this.totalCost(rate, taxRate, avgRate, periods);
      return rate['total_cost'];
    }.bind(this));

    bestRates = bestRates.slice(0, 3);

    this.setState({
      bestRates: bestRates,
      helpMeChoose: true
    });
  },

  helpMeChoose: function() {
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  render: function() {
    return (
      <div className='content container mortgage-rates'>
        {this.state.helpMeChoose ?
          <HelpMeChoose chooseBestRates={this.chooseBestRates} helpMeChoose={this.helpMeChoose}/>
        :
          null
        }
        <div className='row mtl'>
          <div className='col-sm-6'>
            <span className='typeLowlight'>Sort by:</span>
            <a className='clickable mlm' onClick={_.bind(this.sortBy, null, 'apr')}>APR</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'pmt')}>Monthly Payment</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'rate')}>Rate</a>
          </div>
          <div className='col-sm-6 text-right'>
            {this.state.helpMeChoose ?
              null
            :
              <a className='btn btnSml btnAction' onClick={this.helpMeChoose}>Help me choose</a>
            }
          </div>
        </div>
        {this.state.helpMeChoose ?
          <List rates={this.state.bestRates}/>
        :
          <List rates={this.state.rates}/>
        }
      </div>
    );
  },

  sortBy: function(field) {
    var rates = this.state.helpMeChoose ? this.state.bestRates : this.state.rates;

    if (field == 'apr') {
      var sortedRates = _.sortBy(rates, function (rate) {
        return parseFloat(rate.apr);
      });
    } else if (field == 'pmt') {
      var sortedRates = _.sortBy(rates, function (rate) {
        return parseFloat(rate.monthly_payment);
      });
    } else if (field == 'rate') {
      var sortedRates = _.sortBy(rates, function (rate) {
        return parseFloat(rate.interest_rate);
      });
    }

    console.dir(this.state.helpMeChoose);
    if(this.state.helpMeChoose) {
      this.setState({bestRates: sortedRates});
    }
    else {
      this.setState({rates: sortedRates});
    }
  }
});

module.exports = MortgageRates;
