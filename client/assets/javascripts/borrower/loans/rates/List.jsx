var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var List = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function(){
    return ({
      estimatedPropertyTax: this.props.subjectProperty.estimated_property_tax,
      estimatedHazardInsurance: this.props.subjectProperty.estimated_hazard_insurance,
      estimatedMortgageInsurance: this.props.subjectProperty.estimated_mortgage_insurance,
    });
  },

  propTypes: {
    rates: React.PropTypes.array
  },
  toggleHandler: function(event){
    $(event.target).prev().slideToggle(500);
    $(event.target).find('span').toggleClass('up-state');
  },
  totalCost: function(monthly_payment, mtg_insurrance, tax, hazard_insurrance){
    parseFloat(monthly_payment)+parseFloat(mtg_insurrance) + parseFloat(tax) + parseFloat(hazard_insurrance)
  },

  render: function() {
    return (
      <div className='rates-list'>
        {
          _.map(this.props.programs, function (rate, index) {
            console.log(rate);
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
                  <div className="col-md-6">
                    <h4>Monthly payment details</h4>
                    <div className="row">
                      <div className="col-xs-9">
                        <p>Principle and interest</p>
                        <p>Estimated mortgage insurance</p>
                        <p>Estimated property tax</p>
                        <p>Estimated homeowners insurance</p>
                        <p>Total estimated monthly payment</p>
                      </div>
                      <div className="col-xs-3">
                        <p>{this.formatCurrency(rate.monthly_payment, "$")}</p>
                        <p>
                          {
                            this.state.estimatedMortgageInsurance
                            ?
                            this.formatCurrency(this.state.estimatedMortgageInsurance, "$")
                            :
                            null
                          }
                        </p>
                        <p>
                          {
                            this.state.estimatedPropertyTax
                            ?
                            this.formatCurrency(this.state.estimatedPropertyTax, "$")
                            :
                            null
                          }
                        </p>
                        <p>
                          {
                            this.state.estimatedHazardInsurance
                            ?
                            this.formatCurrency(this.state.estimatedHazardInsurance, "$")
                            :
                            null
                          }
                        </p>
                        <p>
                          total
                        </p>
                      </div>
                    </div>
                    <p className="note">Of all 30-year fixed mortgages on Mortgage Club that you’ve qualified for, this one has the lowest rate and APR.</p>
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