var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates
    }
  },

  onSelect: function(rate) {
    console.log('loan ', this.props.bootstrapData.currentLoan.id);
    location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
  },

  render: function() {
    return (
      <div className='content container'>
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
        {_.map(this.state.rates, function (rate, index) {
          return (
            <div key={index} className={'row mhn roundedCorners bas mvm pvm' + (index % 2 === 0 ? ' backgroundLowlight' : '')}>
              <div className='col-sm-3'>
                <div className='typeBold'>{rate.lender_name}</div>
                Logo
                <div>
                  <span className='typeLowlight'>NMLS: </span>{rate.nmls}
                </div>
              </div>
              <div className='col-sm-6'>
                {rate.product}<br/>
                {this.commafy(rate.apr, 3)}% APR
                <span className='typeLowlight mlm'>Monthly Payment: </span>
                {this.formatCurrency(rate.monthly_payment, '$')}<br/>
                <span className='typeLowlight'>Rate: </span>{this.commafy(rate.interest_rate, 3)}%
                <span className='typeLowlight mlm'>Total Closing Cost: </span>
                {this.formatCurrency(rate.total_fee, '$')}
              </div>
              <div className='col-sm-3 pull-right text-right'>
                <a className='btn btm Sml btnPrimary' onClick={_.bind(this.onSelect, null, rate)}>Select</a>
              </div>
            </div>
          );
        }, this)}
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
