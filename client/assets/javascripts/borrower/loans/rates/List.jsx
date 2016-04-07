var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var Chart = require('./Chart');
var ChartMixin = require('mixins/ChartMixin');

var List = React.createClass({
  mixins: [TextFormatMixin, ChartMixin],
  getInitialState: function(){
    var toggleContentStates = new Array(this.props.programs.length);
    toggleContentStates.fill(false, 0, this.props.programs.length);
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

  componentDidMount: function() {
    if(this.props.helpMeChoose){
      if($("span.glyphicon-menu-down").length > 0){
        $("span.glyphicon-menu-down")[0].click();
      }
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(this.props.helpMeChoose){
      if(prevProps.programs[0].apr !== this.props.programs[0].apr){
        $(".line-chart").empty();
        $(".pie-chart").empty();
        if ($("#piechart0 svg").length == 0){
          var rate = this.props.programs[0];
          var total = this.totalMonthlyPayment(
            rate.monthly_payment,
            this.state.estimatedMortgageInsurance,
            this.state.estimatedPropertyTax,
            this.state.estimatedHazardInsurance
          );
          this.drawPieChart(
            0,
            rate.monthly_payment,
            this.state.estimatedHazardInsurance,
            this.state.estimatedPropertyTax ,
            this.state.estimatedMortgageInsurance,
            this.state.hoaDue,
            total
          );
        }

        if ($("#linechart0 svg").length == 0){
          var rate = this.props.programs[0];
          this.drawLineChart(0, rate.period, parseInt(rate.loan_amount), rate.interest_rate, rate.monthly_payment);
        }
      }
    }
  },

  calDownPayment: function(down_payment, loan_amount){
    return parseFloat(down_payment/loan_amount)*100;
  },

  toggleHandler: function(index, event){
    var currentState = this.state.toggleContentStates;
    var selectedBoardContent = $("#board-content-" + index);
    currentState[index] = !currentState[index];
    this.setState(currentState);

    if(selectedBoardContent.css("display") == "none"){
      selectedBoardContent.slideToggle(500);
      $(event.target).find('span').toggleClass('up-state');
      if ($("#piechart" + index + " svg").length == 0){
        var rate = this.props.programs[index];
        var total = this.totalMonthlyPayment(
          rate.monthly_payment,
          this.state.estimatedMortgageInsurance,
          this.state.estimatedPropertyTax,
          this.state.estimatedHazardInsurance
        );
        this.drawPieChart(
          index,
          rate.monthly_payment,
          this.state.estimatedHazardInsurance,
          this.state.estimatedPropertyTax ,
          this.state.estimatedMortgageInsurance,
          this.state.hoaDue,
          total
        );
      }

      if ($("#linechart" + index + " svg").length == 0){
        var rate = this.props.programs[index];
        this.drawLineChart(index, rate.period, parseInt(rate.loan_amount), rate.interest_rate, rate.monthly_payment);
      }
    }
    else {
      selectedBoardContent.slideToggle(500);
      $(event.target).find('span').toggleClass('up-state');
    }
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

  estimatedClosingCost: function(rate) {
    var estimatedClosingCost = parseFloat(rate.lender_credits) || 0.00;

    if(rate.fees.length === 0) {
      return estimatedClosingCost;
    }

    _.map(rate.fees, function(fee) {
      estimatedClosingCost += parseFloat(fee.FeeAmount) || 0.00;
    });
    return estimatedClosingCost;
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
                      <img className="img-responsive" src={rate.logo_url}/>
                      <h4 className="nmls-title">NMLS: #{rate.nmls}</h4>
                    </div>

                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <h3 className="text-capitalize">{rate.lender_name}</h3>
                      <p>{rate.product}</p>
                      <h1 className="apr-text">{this.commafy(rate.apr * 100, 3)}% APR</h1>
                    </div>

                    <div className="col-md-4 col-sm-6 col-sm-6">
                      <p><span className="text-capitalize">rate:</span> {this.commafy(rate.interest_rate * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(rate.monthly_payment, '$')}</p>
                      <p><span className="text-capitalize">estimated closing costs:</span> {this.formatCurrency(this.estimatedClosingCost(rate), '$')}</p>
                    </div>

                    <div className="col-md-2 col-sm-6 col-sm-6">
                      <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, rate)}>Select</a>
                    </div>
                  </div>
                </div>
                <div id={"board-content-" + index} className={this.state.toggleContentStates[index]===true ? "board-content" :"board-content up-state"}>
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
                          <p className="col-xs-12 cost">{this.commafy(rate.apr * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.loan_amount, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.down_payment, "$")} ({this.calDownPayment(rate.down_payment, rate.loan_amount)}%)</p>
                        </div>
                      </div>
                      <h4>Estimated Closing Costs</h4>
                      <ul className="fee-items">
                        {
                          rate.lender_credits == 0
                          ?
                            null
                          :
                            <li className="lender-fee-item">{rate.lender_credits < 0 ? "Lender credit" : "Discount points"}: {this.formatCurrency(rate.lender_credits)}</li>
                        }
                        {
                          _.map(rate.fees, function(fee){
                            return (
                              <li className="lender-fee-item" key={fee["HudLine"]}>{fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], '$')}</li>
                            )
                          }, this)
                        }
                      </ul>
                      {
                        this.props.helpMeChoose
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
                          <p className="col-xs-12 cost">Principal and interest</p>
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
                      {
                        rate.characteristic
                        ?
                          <p className="note">{rate.characteristic}</p>
                        :
                          null
                      }
                    </div>
                  </div>

                  <Chart id={index} principle={rate.monthly_payment} mortgageInsurance={this.state.estimatedMortgageInsurance} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                    hoadue={this.state.hoaDue} numOfMonths={rate.period} loanAmount={rate.loan_amount} interestRate={rate.interest_rate}
                    total={this.totalMonthlyPayment(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance)} />

                </div>
                <div className="board-content-toggle" onClick={_.bind(this.toggleHandler, null, index)}>
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