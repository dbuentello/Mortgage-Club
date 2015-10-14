var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var List = require('./List');
var HelpMeChoose = require('./HelpMeChoose');
var DocusignIframe = require('./DocusignIframe');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates,
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
  },

  helpMeChoose: function() {
    this.setState({helpMeChoose: !this.state.helpMeChoose});
  },

  render: function() {
    // don't want to make ugly code
    var guaranteeMessage = "We're showing the best 3 loan options for you";

    return (
      <div>

        { this.state.signDoc
          ?
            <DocusignIframe loanID={this.props.bootstrapData.currentLoan.id} rate={this.state.selectedRate}/>
          :
            <div className='content container mortgage-rates'>
              { this.state.helpMeChoose
                ?
                  <HelpMeChoose choosePossibleRates={this.choosePossibleRates} helpMeChoose={this.helpMeChoose} bestRate={this.state.bestRate} selectRate={this.selectRate}/>
                :
                null
              }
              <div className='row mtl'>
                { this.state.helpMeChoose
                  ?
                    null
                  :
                    <div className='col-sm-6'>
                      <span className='typeLowlight'>Sort by:</span>
                      <a className='clickable mlm' onClick={_.bind(this.sortBy, null, 'apr')}>APR</a>
                      <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'pmt')}>Monthly Payment</a>
                      <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'rate')}>Rate</a>
                    </div>
                }
                { this.state.possibleRates
                  ?
                    <div className='col-sm-6'>
                      <b>{guaranteeMessage}</b>
                    </div>
                  :
                    null
                }
                <div className='col-sm-6 text-right'>
                  { this.state.helpMeChoose
                    ?
                      null
                    :
                      <a className='btn btnSml btnAction' onClick={this.helpMeChoose}>Help me choose</a>
                  }
                </div>
              </div>
              { this.state.helpMeChoose
                ?
                  <List rates={this.state.possibleRates} selectRate={this.selectRate}/>
                :
                  <List rates={this.state.rates} selectRate={this.selectRate}/>
              }
            </div>
        }
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
