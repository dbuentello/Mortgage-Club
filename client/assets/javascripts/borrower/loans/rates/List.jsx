var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var List = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    rates: React.PropTypes.array
  },
  toggleHandler: function(event){
    $(event.target).prev().slideToggle(500);
    $(event.target).find('span').toggleClass('up-state');
  },

  render: function() {
    return (
      <div className='rates-list'>
        {
          _.map(this.props.rates, function (rate, index) {
            return (
              <div key={index} className="row roundedCorners bas mvm pvm choose-board board">
                <div className="board-header">
                  <div className="row">
                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <img src="choose1.jpg" className="img-responsive"/>
                      <h4>NMLS: {rate.nmls}</h4>
                    </div>

                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <h3 className="text-capitalize">{rate.lender_name}</h3>
                      <p>{rate.product}</p>
                      <h1 className="apr-text">{this.commafy(rate.apr, 3)}% APR</h1>
                    </div>

                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <p><span className="text-capitalize">rate:</span> {this.commafy(rate.interest_rate * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(rate.monthly_payment, '$')}</p>
                      <p><span className="text-capitalize">total closing cost:</span> {this.formatCurrency(rate.total_closing_cost, '$')}</p>
                    </div>

                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, rate)}>Select</a>
                    </div>
                  </div>
                </div>
                <div className="row">
                  <div className="col-md-6">
                    <h4>Product details</h4>
                    <div className="row">
                      <div className="col-xs-6">
                        <p>Product type</p>
                        <p>Interest Rate</p>
                        <p>APR</p>
                        <p>Loan amount</p>
                        <p>Down payment</p>
                      </div>
                      <div className="col-xs-6">
                        <p>{rate.product}</p>
                        <p>{this.commafy(rate.interest_rate * 100, 3)}%</p>
                        <p>{this.commafy(rate.apr, 3)}%</p>
                        <p>{this.formatCurrency(rate.loan_amount, "$")}</p>
                        <p>{this.formatCurrency(rate.down_payment, "$")}</p>
                      </div>
                    </div>

                      <h4>Lender fees</h4>
                      <ul>
                        {
                          _.map(Object.keys(rate.fees), function(key){
                            return (
                              <li key={key}>{key}: {this.formatCurrency(rate.fees[key], '$')}</li>
                            )
                          }, this)
                        }
                      </ul>
                    </div>
                <div className='col-sm-3'>
                  <div className='typeBold'>{rate.lender_name}</div>
                  Logo
                  <div>
                    <h4>NMLS: {rate.nmls} </h4>
                  </div>
                </div>
                <div className='col-sm-6'>
                  <span className='typeLowlight mlm'>Lender credit: </span>
                  {rate.lender_credit ? this.formatCurrency(rate.lender_credit, '$') : "$0"}
                  <br/>
                  <span className='typeLowlight mlm'>Fees: </span>
                  {
                    this.props.displayTotalCost
                    ?
                      <div>
                        <span className='typeLowlight mlm'>True Cost of Mortgage: </span>
                        {this.formatCurrency(rate.total_cost, '$')}
                      </div>
                    :
                      null
                  }
                </div>

                </div>
                <div className="board-content-toggle" onClick={this.toggleHandler}>
                  <span className="glyphicon glyphicon-menu-down"></span>
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