var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var Chart = require('./Chart');

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
    var total = 0.0;
    if(monthly_payment){
      total += parseFloat(monthly_payment);
    }
    if(mtg_insurrance){
      total += parseFloat(mtg_insurrance)
    }
    if(tax){
      total += parseFloat(tax);
    }
    if(hazard_insurrance){
      total += parseFloat(hazard_insurrance);
    }
    return total;
  },

  render: function() {
    return (
      <div className='rates-list'>
        {
          _.map(this.props.programs, function (rate, index) {
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
                        <p className="col-xs-12 cost">Product type</p>
                        <p className="col-xs-12 cost">Interest Rate</p>
                        <p className="col-xs-12 cost">APR</p>
                        <p className="col-xs-12 cost">Loan amount</p>
                        <p className="col-xs-12 cost">Down payment</p>
                      </div>
                      <div className="col-xs-6">
                        <p className="col-xs-12 cost">{rate.product}</p>
                        <p className="col-xs-12 cost">{this.commafy(rate.interest_rate * 100, 3)}%</p>
                        <p className="col-xs-12 cost">{this.commafy(rate.apr, 3)}%</p>
                        <p className="col-xs-12 cost">{this.formatCurrency(rate.loan_amount, "$")}</p>
                        <p className="col-xs-12 cost">{this.formatCurrency(rate.down_payment, "$")}</p>
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
                        <p className="col-xs-12 cost">Principle and interest</p>
                        <p className="col-xs-12 cost">Estimated mortgage insurance</p>
                        <p className="col-xs-12 cost">Estimated property tax</p>
                        <p className="col-xs-12 cost">Estimated homeowners insurance</p>
                        <p className="col-xs-12 cost">Total estimated monthly payment</p>
                      </div>
                      <div className="col-xs-3">
                        <p className="col-xs-12 cost">{this.formatCurrency(rate.monthly_payment, "$")}</p>
                        <p className="col-xs-12 cost">
                          {
                            this.state.estimatedMortgageInsurance
                            ?
                            this.formatCurrency(this.state.estimatedMortgageInsurance, "$")
                            :
                            null
                          }
                        </p>
                        <p className="col-xs-12 cost">
                          {
                            this.state.estimatedPropertyTax
                            ?
                            this.formatCurrency(this.state.estimatedPropertyTax, "$")
                            :
                            null
                          }
                        </p>
                        <p className="col-xs-12 cost">
                          {
                            this.state.estimatedHazardInsurance
                            ?
                            this.formatCurrency(this.state.estimatedHazardInsurance, "$")
                            :
                            null
                          }
                        </p>
                        <p className="col-xs-12 cost">
                          {this.formatCurrency(this.totalCost(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance), "$")}
                        </p>
                      </div>
                    </div>
                    <p className="note">Of all 30-year fixed mortgages on Mortgage Club that you’ve qualified for, this one has the lowest rate and APR.</p>
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

                <Chart id={index} principle={rate.monthly_payment} mortgageInsurance={this.state.estimatedMortgageInsurance} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                  hoadue={this.state.hoadue} total={this.totalCost(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance)} />

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