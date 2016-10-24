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

    this.props.quotes.map(function(quote){
      quote.thirty_fees[quote.thirty_fees.length-1].Fees[1].FeeAmount = hazardInsurance * 12;
      quote.thirty_fees[quote.thirty_fees.length-1].FeeAmount += hazardInsurance * 12;
      quote.total_closing_cost += hazardInsurance * 12;
    });

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
    $(".text-discount-points:contains('Lender') .fa").attr("title", "You pay a higher interest rate and the lender gives you money (called \"lender credit\") to offset your closing costs.")
    $(".text-discount-points:contains('Discount') .fa").attr("title", "Discount points are money you pay upfront to lower the interest rate. They are tax deductible.")
    $(".text-discount-points:contains('Lender') .fa").attr("data-original-title", "You pay a higher interest rate and the lender gives you money (called \"lender credit\") to offset your closing costs.")
    $(".text-discount-points:contains('Discount') .fa").attr("data-original-title", "Discount points are money you pay upfront to lower the interest rate. They are tax deductible.")

    $("[data-toggle='tooltip']").tooltip();
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
                    <div className="col-xs-4 col-md-3 col-sm-6">
                      <img src={quote.logo_url}/>
                      <h4 className="nmls-title hidden-xs">NMLS: #{quote.nmls}</h4>
                    </div>
                    <div className="col-xs-8 col-md-3 col-sm-6 col-sm-6">
                      <h3 className="text-capitalize">{quote.lender_name}</h3>
                      <p>{quote.product}</p>
                      <h1 className="apr-text">{this.commafy(quote.interest_rate * 100, 3)}% Rate</h1>
                    </div>
                    <div className="col-xs-12 col-md-4 col-sm-6 col-sm-6">
                      <p><span>APR:</span> {this.commafy(quote.apr * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(quote.monthly_payment, 0, "$")}</p>
                      {
                        quote.lender_credits == 0
                        ?
                          <p className="text-discount-points"><span className="text-capitalize">{this.props.quotes[index + 1] == undefined ? "Lender credit" : (this.props.quotes[index + 1].lender_credits <= 0 ? "Lender credit" : "Discount points")}:</span> $0 <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></p>
                        :
                          <p className="text-discount-points"><span className="text-capitalize">{quote.lender_credits < 0 ? "Lender credit" : "Discount points"}:</span> {this.formatCurrency(quote.lender_credits, 0, "$")} <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></p>
                      }
                      <p><span className="text-capitalize">estimated closing costs:</span> {this.formatCurrency(quote.total_closing_cost, 0, "$")} <i className="fa fa-info-circle" title='Closing costs are fees associated at the closing of this transaction. They often include underwriting fee, title, escrow and other third-party fees, and prepaid items. Click "View Details" to see a full breakdown of all the fees you should expect.' data-toggle="tooltip" aria-hidden="true"></i></p>
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
                    {
                      quote.lender_name != "Wells Fargo"
                      ?
                        <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, quote)}>Apply Now</a>
                      :
                        <a className="btn select-btn" target="_blank" href="https://www.wellsfargo.com/mortgage/">Go To Wells Fargo</a>
                    }
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
                          <p className="col-xs-12 cost">Interest rate</p>
                          <p className="col-xs-12 cost">APR</p>
                          <p className="col-xs-12 cost">Property value</p>
                          <p className="col-xs-12 cost">Loan amount</p>
                        </div>
                        <div className="row-no-padding col-xs-6">
                          <p className="col-xs-12 cost">{quote.product}</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.interest_rate * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.apr * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.property_value, 0, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.loan_amount, 0, "$")}</p>
                        </div>
                      </div>
                      <h4>Estimated Closing Costs</h4>
                      <ul className="fee-items">
                        {
                          quote.lender_credits == 0
                          ?
                            <li className="lender-fee-item text-discount-points">{this.props.quotes[index + 1] == undefined ? "Lender credit" : (this.props.quotes[index + 1].lender_credits <= 0 ? "Lender credit" : "Discount points")}: $0 <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></li>
                          :
                            <li className="lender-fee-item text-discount-points">{quote.lender_credits < 0 ? "Lender credit" : "Discount points"}: {this.formatCurrency(quote.lender_credits, 0, "$")} <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true"></i></li>
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
                            var title = "";
                            if(fee["Description"] == "Lender underwriting fee"){
                              title = "This goes to the lender, covering the cost of researching whether or not to approve you for the loan.";
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

                        {
                          _.map(quote.thirty_fees, function(thirty_fee, index_second){
                            var title = "";

                            if(thirty_fee["Description"] == "Services you cannot shop for"){
                              title = "These costs are paid to outside parties, not the lender, but you don’t get to choose them.";
                            }else if (thirty_fee["Description"] == "Services you can shop for"){
                              title = "These costs are paid to outside parties and you are free to shop and compare providers for a variety of services.";
                            }else if (thirty_fee["Description"] == "Prepaid items"){
                              title = "Prepaid items are not a fee, as such, but are costs associated with your home that need to be paid in advance when getting a loan.";
                            }

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
                                      {
                                        title == ""
                                        ?
                                          null
                                        :
                                          <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true" title={title} style={{"margin-left": "3px"}}></i>
                                      }
                                      <div className={"collapse thirty-fees-collapse thirty-fees-" + index + "-" + index_second}>
                                        {
                                          _.map(thirty_fee["Fees"], function(fee) {
                                            var title_child = "";
                                            if (fee["Description"].indexOf("Prepaid interest") > - 1){
                                              title_child = "Prepaid interest for the period from closing to the first mortgage payment.";
                                            }
                                            return (
                                              <p>
                                                {fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], 0, "$")}
                                                {
                                                  title_child == ""
                                                  ?
                                                    null
                                                  :
                                                    <i className="fa fa-info-circle" data-toggle="tooltip" aria-hidden="true" title={title_child} style={{"margin-left": "3px"}}></i>
                                                }
                                              </p>
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
                          {
                            quote.pmi_monthly_premium_amount != 0
                            ?
                              <p className="col-xs-12 cost">Mortgage ins. prem.</p>
                            :
                              null
                          }
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
                      {
                        quote.lender_name != "Wells Fargo"
                        ?
                          <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>The lender will pay MortgageClub 1% in commission.</p>
                        :
                          <p className="note-rates"><i className="fa fa-check" aria-hidden="true"></i>The lender does not pay MortgageClub any commission.</p>
                      }
                    </div>
                  </div>
                  <Chart id={index} principle={quote.monthly_payment} mortgageInsurance={0} propertyTax={this.state.estimatedPropertyTax} hazardInsurance={this.state.estimatedHazardInsurance}
                    hoadue={0} numOfMonths={quote.period} loanAmount={quote.loan_amount} interestRate={quote.interest_rate}
                    total={this.totalMonthlyPayment(quote.monthly_payment, 0, this.state.estimatedPropertyTax, this.state.estimatedHazardInsurance, 0, quote.pmi_monthly_premium_amount)} />
                </div>
                <div className="board-content-toggle">
                  <button onClick={_.bind(this.toggleHandler, null, index)}>
                    <span>View Details</span>
                    <span className={this.state.toggleContentStates[index]===true ? "fa fa-angle-up" : "fa fa-angle-down"} style={{"font-size": "20px", "margin-left": "5px", "vertical-align": "middle"}}></span>
                  </button>
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
