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

    var estimatedPropertyTax = (this.props.subjectProperty.estimated_property_tax == undefined || this.props.subjectProperty.estimated_property_tax == null) ? 0 : this.props.subjectProperty.estimated_property_tax / 12;
    var estimatedHazardInsurance = (this.props.subjectProperty.estimated_hazard_insurance == undefined || this.props.subjectProperty.estimated_hazard_insurance == null) ? 0 : this.props.subjectProperty.estimated_hazard_insurance / 12;

    this.props.programs.map(function(program){
      program.prepaid_fees[1].FeeAmount = estimatedHazardInsurance * 12;
      program.prepaid_fees.FeeAmount += estimatedHazardInsurance * 12;
      program.total_prepaid_fees += estimatedHazardInsurance * 12;
    });

    return ({
      estimatedPropertyTax: estimatedPropertyTax,
      estimatedHazardInsurance: estimatedHazardInsurance,
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
    }else {
      if(this.props.selected_program == 2) {
        if($(".board-content-toggle span.glyphicon-menu-down").length > 0){
          setTimeout(function(){
          $(".board-content-toggle span.glyphicon-menu-down")[0].click();
        }, 2000);
        }
      }
    }

    $('.collapse').on('shown.bs.collapse', function(){
      $(this).parent().find(".icon-plus").removeClass("icon-plus").addClass("icon-minus");
    }).on('hidden.bs.collapse', function(){
      $(this).parent().find(".icon-minus").removeClass("icon-minus").addClass("icon-plus");
    });
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
            this.state.estimatedHazardInsurance,
            this.state.hoaDue,
            rate.pmi_monthly_premium_amount
          );
          this.drawPieChart(
            0,
            rate.monthly_payment,
            this.state.estimatedHazardInsurance,
            this.state.estimatedPropertyTax ,
            this.state.estimatedMortgageInsurance,
            this.state.hoaDue,
            rate.pmi_monthly_premium_amount,
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

  toggleHandler: function(index, event){
    var currentState = this.state.toggleContentStates;
    var selectedBoardContent = $("#board-content-" + index);
    currentState[index] = !currentState[index];
    this.setState(currentState);

    if(selectedBoardContent.css("display") == "none"){
      $(event.target).parent().find("span:first").text("Hide Details");
      selectedBoardContent.slideToggle(500);
      $(event.target).find('span').toggleClass('up-state');

      if ($("#piechart" + index + " svg").length == 0){
        var rate = this.props.programs[index];
        var total = this.totalMonthlyPayment(
          rate.monthly_payment,
          this.state.estimatedMortgageInsurance,
          this.state.estimatedPropertyTax,
          this.state.estimatedHazardInsurance,
          this.state.hoaDue,
          rate.pmi_monthly_premium_amount
        );
        this.drawPieChart(
          index,
          rate.monthly_payment,
          this.state.estimatedHazardInsurance,
          this.state.estimatedPropertyTax ,
          this.state.estimatedMortgageInsurance,
          this.state.hoaDue,
          rate.pmi_monthly_premium_amount,
          total
        );
      }

      if ($("#linechart" + index + " svg").length == 0){
        var rate = this.props.programs[index];
        this.drawLineChart(index, rate.period, parseInt(rate.loan_amount), rate.interest_rate, rate.monthly_payment);
      }
    }
    else {
      $(event.target).parent().find("span:first").text("View Details");
      selectedBoardContent.slideToggle(500);
      $(event.target).find('span').toggleClass('up-state');
    }
  },

  totalMonthlyPayment: function(monthly_payment, mtg_insurrance, tax, hazard_insurrance, hoa_due, mortgage_insurance_premium){
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
    if(mortgage_insurance_premium){
      total += parseFloat(mortgage_insurance_premium);
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
                    <div className="col-md-3 col-sm-6 col-xs-4">
                      <img src={rate.logo_url}/>

                      <h4 className="nmls-title hidden-xs">NMLS: #{rate.nmls}</h4>
                    </div>
                    <div className="col-md-3 col-sm-6 col-sm-6 col-xs-8">
                      <h3 className="text-capitalize">{rate.lender_name}</h3>
                      <p>{rate.product}</p>
                      <h1 className="apr-text">{this.commafy(rate.interest_rate * 100, 3)}% Rate</h1>
                    </div>
                    <div className="col-md-4 col-sm-6 col-sm-6">
                      <p><span>APR:</span> {this.commafy(rate.apr * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(rate.monthly_payment, 0, '$')}</p>
                      <p><span className="text-capitalize">{rate.lender_fee >= 0 ? "Lender Fees" : "Lender Credit"}:</span> {this.formatCurrency(rate.lender_fee, 0, "$")}</p>
                      <p><span className="text-capitalize">closing costs:</span> {this.formatCurrency(rate.total_closing_cost, 0, '$')}</p>
                      {
                        this.props.helpMeChoose
                        ?
                          <p>
                            <strong>
                              <span>True Cost of Mortgage: </span>
                              {this.formatCurrency(rate.total_cost, 0, '$')}
                            </strong>
                          </p>
                        :
                          null
                      }
                    </div>
                    <div className="col-md-2 col-sm-12 text-sm-center">
                      {
                        rate.selected_program
                        ?
                          <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, rate)}>Continue</a>
                        :
                          <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, rate)}>Select</a>
                      }
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
                          <p className="col-xs-12 cost">Interest rate</p>
                          <p className="col-xs-12 cost">APR</p>
                          <p className="col-xs-12 cost">Property value</p>
                          <p className="col-xs-12 cost">Loan amount</p>
                        </div>
                        <div className="col-xs-6">
                          <p className="col-xs-12 cost">{rate.product}</p>
                          <p className="col-xs-12 cost">{this.commafy(rate.interest_rate * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.commafy(rate.apr * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.property_value, 0, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.loan_amount, 0, "$")}</p>
                        </div>
                      </div>
                      <h4>Cash to Close</h4>
                      <h5><span className="nocolor">Closing Costs: </span><span className="nocolor">{this.formatCurrency(rate.total_closing_cost, 0, "$")}</span></h5>
                      <ul className="fee-items">
                        <li className="thirty-party-fees">
                          <a role="button" data-toggle="collapse" href=".lender-fees" aria-expanded="true" aria-controls=".lender-fees">
                            <i className="icon-plus"></i>
                            {
                              rate.lender_fee >= 0
                              ?
                                <span>{"Lender fees: " + this.formatCurrency(rate.lender_fee, 0, "$")}</span>
                              :
                                <span>{"Lender credit: " + this.formatCurrency(rate.lender_fee, 0, "$")}</span>
                            }
                          </a>
                          <div className="collapse thirty-fees-collapse lender-fees">
                            {
                              rate.lender_underwriting_fee == 0
                              ?
                                null
                              :
                                <p>Underwriting fee: {this.formatCurrency(rate.lender_underwriting_fee, 0, "$")} <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true" title="This goes to the lender, covering the cost of researching whether or not to approve you for the loan."></i></p>
                            }
                            {
                              rate.lender_credits == 0
                              ?
                                <p className="text-discount-points">{this.props.rates[index + 1] == undefined ? "Credit" : (this.props.rates[index + 1].lender_credits <= 0 ? "Credit" : "Discount points")}: $0 <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></p>
                              :
                                <p className="text-discount-points">{rate.lender_credits < 0 ? "Credit" : "Discount points"}: {this.formatCurrency(rate.lender_credits, 0, "$")} <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></p>
                            }
                            {
                              rate.fha_upfront_premium_amount == 0
                              ?
                                null
                              :
                                <p>Upfront mortgage insurance premium: {this.formatCurrency(rate.fha_upfront_premium_amount, 0, "$")}</p>
                            }
                          </div>
                        </li>

                        <li className="thirty-party-fees">
                          <a role="button" data-toggle="collapse" href=".thirty-fees" aria-expanded="true" aria-controls="thirty-fees">
                            <i className="icon-plus"></i><span>Third party fees</span>
                          </a>
                          <div className="collapse thirty-fees-collapse thirty-fees">
                            {
                              _.map(rate.thirty_fees, function(fee) {
                                return (
                                  <p>
                                    {fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], 0, "$")}
                                  </p>
                                )
                              }, this)
                            }
                          </div>
                        </li>
                      </ul>
                      <h5>Prepaid Items</h5>
                      <ul className="fee-items">
                      {
                        _.map(rate.prepaid_fees, function(fee){
                            var title = "";
                            if (fee["Description"].indexOf("Prepaid interest") > - 1){
                              title = "Prepaid interest for the period from closing to the first mortgage payment.";
                            }

                            return (
                              <li className="lender-fee-item" key={fee["HudLine"]}>
                                {fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], 0, "$")}
                                &nbsp;
                                {
                                  title == ""
                                  ?
                                    null
                                  :
                                    <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true" title={title}></i>
                                }
                              </li>
                            )
                          }, this)
                      }
                      </ul>
                      <div style={{"font-weight": "bold"}}>Total Cash to Close: {this.formatCurrency(rate.total_closing_cost + rate.total_prepaid_fees, 0, "$")}</div>
                    </div>
                    <div className="col-md-6">
                      <h4>Monthly payment details</h4>
                      <div className="row">
                        <div className="col-xs-9">
                          <p className="col-xs-12 cost">Principal and interest</p>
                          {
                            this.state.estimatedMortgageInsurance
                            ?
                              <p className="col-xs-12 cost">Estimated mortgage insurance</p>
                            :
                              null
                          }
                          <p className="col-xs-12 cost">Estimated property tax</p>
                          <p className="col-xs-12 cost">Estimated homeowners insurance</p>
                          {
                            this.state.hoaDue
                            ?
                              <p className="col-xs-12 cost">HOA Due</p>
                            :
                              null
                          }
                          {
                            rate.pmi_monthly_premium_amount
                            ?
                              <p className="col-xs-12 cost">Mortgage insurance premium</p>
                            :
                              null
                          }
                          <p className="col-xs-12 cost">Total estimated monthly payment</p>
                        </div>
                        <div className="col-xs-3">
                          <p className="col-xs-12 cost">{this.formatCurrency(rate.monthly_payment, 0, "$")}</p>
                          {
                            this.state.estimatedMortgageInsurance
                            ?
                              <p className="col-xs-12 cost">
                                {this.formatCurrency(this.state.estimatedMortgageInsurance, 0, "$")}
                              </p>
                            :
                              null
                          }
                          <p className="col-xs-12 cost">
                            {
                              this.state.estimatedPropertyTax
                              ?
                                this.formatCurrency(this.state.estimatedPropertyTax, 0, "$")
                              :
                                this.formatCurrency("0", 0, "$")
                            }
                          </p>
                          <p className="col-xs-12 cost">
                            {
                              this.state.estimatedHazardInsurance
                              ?
                                this.formatCurrency(this.state.estimatedHazardInsurance, 0, "$")
                              :
                                this.formatCurrency("0", 0, "$")
                            }
                          </p>
                          {
                            this.state.hoaDue
                            ?
                              <p className="col-xs-12 cost">
                                {this.formatCurrency(this.state.hoaDue, 0, "$")}
                              </p>
                            :
                              null
                          }
                          {
                            rate.pmi_monthly_premium_amount
                            ?
                              <p className="col-xs-12 cost">
                                {this.formatCurrency(rate.pmi_monthly_premium_amount, 0, "$")}
                              </p>
                            :
                              null
                          }
                          <p className="col-xs-12 cost">
                            {this.formatCurrency(this.totalMonthlyPayment(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, this.state.hoaDue, rate.pmi_monthly_premium_amount), 0, "$")}
                          </p>
                        </div>
                      </div>
                      {
                        rate.characteristic
                        ?
                          <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>{rate.characteristic}</p>
                        :
                          null
                      }
                      <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>The lender will pay MortgageClub {rate.commission}% in commission.</p>
                    </div>
                  </div>
                  <Chart id={index} principle={rate.monthly_payment} mortgageInsurance={this.state.estimatedMortgageInsurance} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                    hoadue={this.state.hoaDue} numOfMonths={rate.period} loanAmount={rate.loan_amount} interestRate={rate.interest_rate}
                    total={this.totalMonthlyPayment(rate.monthly_payment, this.state.estimatedMortgageInsurance, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, rate.pmi_monthly_premium_amount)} />
                </div>
                <div className="board-content-toggle" onClick={_.bind(this.toggleHandler, null, index)}>
                  <span>View Details</span>
                  <span className={this.state.toggleContentStates[index]===true ? "glyphicon glyphicon-menu-up" : "glyphicon glyphicon-menu-down"} style={{"font-size": "20px", "margin-left": "5px", "vertical-align": "middle"}}></span>
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
