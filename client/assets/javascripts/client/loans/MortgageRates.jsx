var _ = require('lodash');
var React = require('react/addons');
var Router = require('react-router');

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Router.Navigation],

  componentDidMount: function() {
    $.ajax({
      method: 'GET',
      url: window.location.pathname,
      data: {data: true},
      context: this,
      dataType: 'json',
      success: function(response) {
        var rates = this.getValue(response, 'Result.TransactionData.PRODUCTS.PRODUCT');
        // if (rates) {
        //   rates = rates.reverse();
        // }
        this.setState({ loaded: true, rates: rates });
      },
      error: function(response, status, error) {

      }
    });
  },

  onSelect: function(rate) {
    // console.dir(rate);
    $.ajax({
      url: '/rates/select',
      method: 'POST',
      dataType: 'json',
      data: {rate: rate},
      success: function(response) {
        this.context.router.transitionTo('new_loan');
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  render: function() {
    if (!this.state.loaded) {
      return (
        <div className='content container text-center'>
          {this.renderLoader()}
        </div>
      );
    }

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
                <div className='typeBold'>{rate.EntityName}</div>
                Logo
                <div>
                  <span className='typeLowlight'>NMLS: </span>#Some number
                </div>
              </div>
              <div className='col-sm-6'>
                {rate.ProductName}<br/>
                {this.commafy(rate.OriginationAPR, 3)}% APR
                <span className='typeLowlight mlm'>Monthly Payment: </span>
                {this.formatCurrency(rate.OriginationPandI, '$')}<br/>
                <span className='typeLowlight'>Rate: </span>{this.commafy(rate.Rate, 3)}%
                <span className='typeLowlight mlm'>Total Closing Cost: </span>
                {this.formatCurrency(rate.OriginationTotalClosingCost, '$')}
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
        return parseFloat(rate.OriginationAPR);
      })});
    } else if (field == 'pmt') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.OriginationPandI);
      })});
    } else if (field == 'rate') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.Rate);
      })});
    }
  }
});

module.exports = MortgageRates;
