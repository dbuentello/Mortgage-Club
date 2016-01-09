var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var Chart = require('./Chart');

var List = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function(){
    var toggleContentStates = new Array(this.props.programs.length);
    toggleContentStates.fill(false, 0, this.props.programs.length);
    toggleContentStates[0] = true;
    return ({
      estimatedPropertyTax: this.props.subjectProperty.estimated_property_tax,
      estimatedHazardInsurance: this.props.subjectProperty.estimated_hazard_insurance,
      estimatedMortgageInsurance: this.props.subjectProperty.estimated_mortgage_insurance,
      hoaDue: this.props.subjectProperty.hoa_due,
      toggleContentStates: toggleContentStates
    });
  },

  propTypes: {
    programs: React.PropTypes.array
  },

  calDownPayment: function(down_payment, loan_amount){
    return parseFloat(down_payment/loan_amount)*100;
  },

  toggleHandler: function(event, index){
    var currentState = this.state.toggleContentStates;
    currentState[index] = !currentState[index];
    this.setState(currentState)
    $(event.target).prev().slideToggle(500);
    $(event.target).find('span').toggleClass('up-state');
  },

  totalMonthlyPayment: function(monthly_payment, mtg_insurrance, tax, hazard_insurrance, hoa_due){
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
    if(hoa_due){
      total += parseFloat(hoa_due);
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
                      <img className="img-responsive"/>
                      <h4>NMLS: #{rate.nmls}</h4>
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
                <div className={this.state.toggleContentStates[index]===true ? "board-content" :"board-content up-state"}>
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
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.down_payment, "$")} ({this.calDownPayment(rate.down_payment, rate.loan_amount)}%)</p>
                        </div>
                      </div>
                      <h4>Lender fees</h4>
                      <ul className="fee-items">
                        {
                          _.map(Object.keys(rate.fees), function(key){
                            return (
                              <li className="lender-fee-item" key={key}>{key}: {this.formatCurrency(rate.fees[key], '$')}</li>
                            )
                          }, this)
                        }
                      </ul>
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
                    <div className="col-md-6">
                      <h4>Monthly payment details</h4>
                      <div className="row">
                        <div className="col-xs-9">
                          <p className="col-xs-12 cost">Principle and interest</p>
                          <p className="col-xs-12 cost">Estimated mortgage insurance</p>
                          <p className="col-xs-12 cost">Estimated property tax</p>
                          <p className="col-xs-12 cost">Estimated homeowners insurance</p>
                          <p className="col-xs-12 cost">Hoa Due</p>
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
                              this.formatCurrency("0", "$")
                            }
                          </p>
                          <p className="col-xs-12 cost">
                            {
                              this.state.estimatedPropertyTax
                              ?
                              this.formatCurrency(this.state.estimatedPropertyTax, "$")
                              :
                              this.formatCurrency("0", "$")
                            }
                          </p>
                          <p className="col-xs-12 cost">
                            {
                              this.state.estimatedHazardInsurance
                              ?
                              this.formatCurrency(this.state.estimatedHazardInsurance, "$")
                              :
                              this.formatCurrency("0", "$")
                            }
                          </p>
                          <p className="col-xs-12 cost">
                            {
                              this.state.hoaDue
                              ?
                              this.formatCurrency(this.state.hoaDue, "$")
                              :
                              this.formatCurrency("0", "$")
                            }
                          </p>
                          <p className="col-xs-12 cost">
                            {this.formatCurrency(this.totalMonthlyPayment(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, this.state.hoaDue), "$")}
                          </p>
                        </div>
                      </div>
                      <p className="note">Of all 30-year fixed mortgages on Mortgage Club that you’ve qualified for, this one has the lowest rate and APR.</p>
                    </div>
                  </div>

                  <Chart id={index} principle={rate.monthly_payment} mortgageInsurance={this.state.estimatedMortgageInsurance} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                    hoadue={this.state.hoaDue} total={this.totalMonthlyPayment(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance)} />

                </div>
                <div className="board-content-toggle" onClick={this.toggleHandler}>
                  <span className={this.state.toggleContentStates[index]===true ? "glyphicon glyphicon-menu-up" : "glyphicon glyphicon-menu-down"}></span>
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