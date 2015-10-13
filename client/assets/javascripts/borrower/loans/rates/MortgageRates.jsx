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
      possibleRates: null,
      bestRate: null,
      helpMeChoose: false
    }
  },

  onSelect: function(rate) {
    // console.dir(rate['fees'])
    // location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
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

  helpMeChoose: function() {
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  render: function() {
    return (
      <div className='content container mortgage-rates'>
        {this.state.helpMeChoose ?
          <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate}/>
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
          <List rates={this.state.possibleRates}/>
        :
          <List rates={this.state.rates}/>
        }
      </div>
    );
  },

  sortBy: function(field) {
    var rates = this.state.helpMeChoose ? this.state.possibleRates : this.state.rates;

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

    // console.dir(this.state.helpMeChoose);
    if(this.state.helpMeChoose) {
      this.setState({possibleRates: sortedRates});
    }
    else {
      this.setState({rates: sortedRates});
    }
  }
});

module.exports = MortgageRates;
