/**
 * Show list quotes in homepage
 */
var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var Chart = require("borrower/loans/rates/Chart");
var ChartMixin = require("mixins/ChartMixin");

var List = React.createClass({
  mixins: [TextFormatMixin, ChartMixin],

  getInitialState: function() {
    var toggleContentStates = [this.props.quotes.length];
    var propertyTax = 0;
    var hazardInsurance = 0;

    if (this.props.monthlyPayment !== null && this.props.monthlyPayment !== undefined){
      propertyTax = this.props.monthlyPayment.property_tax;
      hazardInsurance = this.props.monthlyPayment.hazard_insurance;
    }

    toggleContentStates.fill(false, 0, this.props.quotes.length);
    return {
      toggleContentStates: toggleContentStates,
      estimatedPropertyTax: propertyTax,
      estimatedHazardInsurance: hazardInsurance
    }
  },

  toggleHandler: function(index, event){
    var currentState = this.state.toggleContentStates;
    var selectedBoardContent = $("#board-content-" + index);
    currentState[index] = !currentState[index];
    this.setState(currentState);
    if(selectedBoardContent.css("display") == "none") {
      selectedBoardContent.slideToggle(500);
      $(event.target).find("span").toggleClass("up-state");

      if(this.state.estimatedPropertyTax !== 0 && this.state.estimatedHazardInsurance !== 0){
        if ($("#piechart" + index + " svg").length == 0){
          var quote = this.props.quotes[index];
          var total = this.totalMonthlyPayment(
            quote.monthly_payment,
            0,
            this.state.estimatedPropertyTax,
            this.state.estimatedHazardInsurance,
            0,
            quote.pmi_monthly_premium_amount
          );
          this.drawPieChart(
            index,
            quote.monthly_payment,
            this.state.estimatedHazardInsurance,
            this.state.estimatedPropertyTax,
            0,
            0,
            quote.pmi_monthly_premium_amount,
            total
          );
        }
      }

      if ($("#linechart" + index + " svg").length == 0){
        var quote = this.props.quotes[index];
        this.drawLineChart(index, quote.period, parseInt(quote.loan_amount), quote.interest_rate, quote.monthly_payment);
      }
    }
    else {
      selectedBoardContent.slideToggle(500);
      $(event.target).find("span").toggleClass("up-state");
    }
  },

  componentDidMount: function() {
    if(this.props.helpMeChoose){
      if($("span.fa-angle-down").length > 0){
        $("span.fa-angle-down")[0].click();
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
      if(prevProps.quotes[0].apr !== this.props.quotes[0].apr){
        $(".line-chart").empty();
        $(".pie-chart").empty();

        if(this.state.estimatedPropertyTax !== 0 && this.state.estimatedHazardInsurance !== 0){
          if ($("#piechart0 svg").length == 0){
            var quote = this.props.quotes[0];
            var total = this.totalMonthlyPayment(
              quote.monthly_payment,
              0,
              this.state.estimatedPropertyTax,
              this.state.estimatedHazardInsurance,
              0,
              quote.pmi_monthly_premium_amount
            );
            this.drawPieChart(
              0,
              quote.monthly_payment,
              this.state.estimatedHazardInsurance,
              this.state.estimatedPropertyTax,
              0,
              0,
              quote.pmi_monthly_premium_amount,
              total
            );
          }
        }

        if ($("#linechart0 svg").length == 0){
          var quote = this.props.quotes[0];
          this.drawLineChart(0, quote.period, parseInt(quote.loan_amount), quote.interest_rate, quote.monthly_payment);
        }
      }
    }
  },

  calcDownPayment: function(down_payment, loan_amount){
    if(!down_payment)
      return 0;

    return (parseFloat(down_payment/(down_payment + loan_amount)) * 100).toFixed(0);
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
    return(
      <div>
        {
          _.map(this.props.quotes, function (quote, index) {
            return (
              <div key={index} className="row roundedCorners bas mvm pvm choose-board board">
                <div className="board-header">
                  <div className="row">
                    <div className="col-xs-4 col-md-3 col-sm-6 col-sm-6">
                      <img className="img-responsive" src={quote.logo_url}/>
                      <h4 className="nmls-title hidden-xs">NMLS: #{quote.nmls}</h4>
                    </div>
                    <div className="col-xs-8 col-md-3 col-sm-6 col-sm-6">
                      <h3 className="text-capitalize">{quote.lender_name}</h3>
                      <p>{quote.product}</p>
                      <h1 className="apr-text">{this.commafy(quote.apr * 100, 3)}% APR</h1>
                    </div>
                    <div className="col-xs-12 col-md-4 col-sm-6 col-sm-6">
                      <p><span className="text-capitalize">rate:</span> {this.commafy(quote.interest_rate * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(quote.monthly_payment, 0, "$")}</p>
                      {
                        quote.lender_credits == 0
                        ?
                          null
                        :
                          <p><span className="text-capitalize">{quote.lender_credits < 0 ? "Lender credit" : "Discount points"}:</span> {this.formatCurrency(quote.lender_credits, 0, "$")}</p>
                      }
                      <p><span className="text-capitalize">estimated closing costs:</span> {this.formatCurrency(quote.total_closing_cost, 0, "$")}</p>
                      {
                        this.props.helpMeChoose
                        ?
                          <p>
                            <strong>
                              <span>True Cost of Mortgage: </span>
                              {this.formatCurrency(quote.total_cost, 0, '$')}
                            </strong>
                          </p>
                        :
                          null
                      }
                    </div>
                    <div className="col-md-2 col-sm-12 text-sm-center">
                      <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, quote)}>Apply Now</a>
                    </div>
                  </div>
                </div>
                <div id={"board-content-" + index} className={this.state.toggleContentStates[index] === true ? "board-content" : "board-content up-state"}>
                  <div className="row">
                    <div className="col-md-6">
                      <h4>Product details</h4>
                      <div className="row">
                        <div className="col-xs-6">
                          <p className="col-xs-12 cost">Product type</p>
                          <p className="col-xs-12 cost">Interest Rate</p>
                          <p className="col-xs-12 cost">APR</p>
                          <p className="col-xs-12 cost">Loan amount</p>
                          {
                            quote.down_payment == null
                            ?
                              null
                            :
                              <p className="col-xs-12 cost">Down payment</p>
                          }
                        </div>
                        <div className="row-no-padding col-xs-6">
                          <p className="col-xs-12 cost">{quote.product}</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.interest_rate * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.apr * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.loan_amount, 0, "$")}</p>
                          {
                            quote.down_payment == null
                            ?
                              null
                            :
                              <p className="col-xs-12 cost">{this.formatCurrency(quote.down_payment, 0, "$")} ({this.calcDownPayment(quote.down_payment, quote.loan_amount)}%)</p>
                          }
                        </div>
                      </div>
                      <h4>Estimated Closing Costs</h4>
                      <ul className="fee-items">
                        {
                          quote.lender_credits == 0
                          ?
                            null
                          :
                            <li className="lender-fee-item">{quote.lender_credits < 0 ? "Lender credit" : "Discount points"}: {this.formatCurrency(quote.lender_credits, 0, "$")}</li>
                        }
                        {
                          quote.fha_upfront_premium_amount == 0
                          ?
                            null
                          :
                            <li className="lender-fee-item">Upfront mortgage insurance premium: {this.formatCurrency(quote.fha_upfront_premium_amount, 0, "$")}</li>
                        }
                        {
                          _.map(quote.fees, function(fee){
                            return (
                              <li className="lender-fee-item" key={fee["HudLine"]}>{fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], 0, "$")}</li>
                            )
                          }, this)
                        }

                        {
                          _.map(quote.thirty_fees, function(thirty_fee, index_second){
                            return (
                              <div>
                                {
                                  thirty_fee["FeeAmount"] == 0
                                  ?
                                    null
                                  :
                                    <li className="thirty-party-fees">
                                      <a role="button" data-toggle="collapse" href={".thirty-fees-" + index + "-" + index_second} aria-expanded="true" aria-controls={"thirty-fees-" + index + "-" + index_second}>
                                        <i className="icon-plus"></i><span>{thirty_fee["Description"] + ": " + this.formatCurrency(thirty_fee["FeeAmount"], 0, "$")}</span>
                                      </a>
                                      <div className={"collapse thirty-fees-collapse thirty-fees-" + index + "-" + index_second}>
                                        {
                                          _.map(thirty_fee["Fees"], function(fee) {
                                            return (
                                              <p>{fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], 0, "$")}</p>
                                            )
                                          }, this)
                                        }
                                      </div>
                                    </li>
                                }
                              </div>
                            )
                          }, this)
                        }
                      </ul>
                    </div>
                    <div className="col-md-6">
                      <h4>Monthly payment details</h4>
                      <div className="row">
                        <div className="col-md-9 col-xs-9 hidden-xs pull-left">
                          <p className="col-xs-12 cost ">Principal and interest</p>
                          <p className="col-xs-12 cost ">Estimated property tax</p>
                          <p className="col-xs-12 cost ">Estimated homeowners insurance</p>
                          {
                            quote.pmi_monthly_premium_amount != 0
                            ?
                              <p className="col-xs-12 cost">Mortgage insurance premium</p>
                            :
                              null
                          }
                          <p className="col-xs-12 cost ">Total estimated monthly payment</p>
                          </div>
                          <div className="col-xs-8 row-no-padding-right visible-xs pull-left">
                          <p className="col-xs-12 cost ">P & I</p>
                          <p className="col-xs-12 cost ">Est. property tax</p>
                          <p className="col-xs-12 cost ">Est. homeowners ins.</p>
                          <p className="col-xs-12 cost "> Total est. payment</p>
                        </div>
                        <div className="row-no-padding col-md-3 col-xs-3">
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.monthly_payment, 0, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(this.state.estimatedPropertyTax, 0, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(this.state.estimatedHazardInsurance, 0, "$")}</p>
                            {
                              quote.pmi_monthly_premium_amount != 0
                              ?
                                <p className="col-xs-12 cost">{this.formatCurrency(quote.pmi_monthly_premium_amount, 0, "$")}</p>
                              :
                                null
                            }
                          <p className="col-xs-12 cost">{this.formatCurrency(this.totalMonthlyPayment(quote.monthly_payment, 0, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, 0, quote.pmi_monthly_premium_amount), 0, "$")}</p>
                        </div>
                      </div>
                      {
                        quote.characteristic
                        ?
                          <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>{quote.characteristic}</p>
                        :
                          null
                      }
                      <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>The lender will pay MortgageClub 1% in commission.</p>
                    </div>
                  </div>
                  <Chart id={index} principle={quote.monthly_payment} mortgageInsurance={0} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                    hoadue={0} numOfMonths={quote.period} loanAmount={quote.loan_amount} interestRate={quote.interest_rate}
                    total={this.totalMonthlyPayment(quote.monthly_payment, 0, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, 0, quote.pmi_monthly_premium_amount)} />
                </div>
                <div className="board-content-toggle">
                  <button onClick={_.bind(this.toggleHandler, null, index)}><span className={this.state.toggleContentStates[index]===true ? "fa fa-angle-up" : "fa fa-angle-down"} ></span></button>
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