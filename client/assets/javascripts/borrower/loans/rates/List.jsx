var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var List = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    rates: React.PropTypes.array
  },

  onSelect: function(selection) {

  },

  render: function() {
    return (
      <div className='rates-list'>
        {
          _.map(this.props.rates, function (rate, index) {
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
          }, this)
        }
      </div>
    )
  }
});

module.exports = List;