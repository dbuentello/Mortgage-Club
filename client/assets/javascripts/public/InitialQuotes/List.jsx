var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ChartMixin = require("mixins/ChartMixin");

var List = React.createClass({
  mixins: [TextFormatMixin, ChartMixin],

  getInitialState: function() {
    var toggleContentStates = [this.props.quotes.length];
    toggleContentStates.fill(false, 0, this.props.quotes.length);

    return {
      toggleContentStates: toggleContentStates,
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
      if($("span.glyphicon-menu-down").length > 0){
        $("span.glyphicon-menu-down")[0].click();
      }
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(this.props.helpMeChoose){
      if(prevProps.quotes[0].apr !== this.props.quotes[0].apr){
        $(".line-chart").empty();
        $(".pie-chart").empty();

        if ($("#linechart0 svg").length == 0){
          var quote = this.props.quotes[0];
          this.drawLineChart(0, quote.period, parseInt(quote.loan_amount), quote.interest_rate, quote.monthly_payment);
        }
      }
    }
  },

  calcDownPayment: function(down_payment, loan_amount){
    return parseFloat(down_payment/loan_amount) * 100;
  },

  estimatedClosingCost: function(quote) {
    var estimatedClosingCost = parseFloat(quote.lender_credits) || 0.00;
    if(quote.fees.length === 0){
      return estimatedClosingCost;
    }

    _.map(quote.fees, function(fee) {
      estimatedClosingCost += parseFloat(fee.FeeAmount) || 0.00;
    });
    return estimatedClosingCost;
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
                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <img className="img-responsive" src={quote.logo_url}/>
                      <h4 className="nmls-title">NMLS: #{quote.nmls}</h4>
                    </div>

                    <div className="col-md-3 col-sm-6 col-sm-6">
                      <h3 className="text-capitalize">{quote.lender_name}</h3>
                      <p>{quote.product}</p>
                      <h1 className="apr-text">{this.commafy(quote.apr * 100, 3)}% APR</h1>
                    </div>

                    <div className="col-md-4 col-sm-6 col-sm-6">
                      <p><span className="text-capitalize">rate:</span> {this.commafy(quote.interest_rate * 100, 3)}%</p>
                      <p><span className="text-capitalize">monthly payment:</span> {this.formatCurrency(quote.monthly_payment, "$")}</p>
                      <p><span className="text-capitalize">estimated closing costs:</span> {this.formatCurrency(this.estimatedClosingCost(quote), "$")}</p>
                    </div>

                    <div className="col-md-2 col-sm-6 col-sm-6">
                      <a className="btn select-btn" onClick={_.bind(this.props.selectRate, null, quote)}>Select</a>
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
                          <p className="col-xs-12 cost">Down payment</p>
                        </div>
                        <div className="col-xs-6">
                          <p className="col-xs-12 cost">{quote.product}</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.interest_rate * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.commafy(quote.apr * 100, 3)}%</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.loan_amount, "$")}</p>
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.down_payment, "$")} ({this.calcDownPayment(quote.down_payment, quote.loan_amount)}%)</p>
                        </div>
                      </div>
                      <h4>Estimated Closing Costs</h4>
                      <ul className="fee-items">
                        {
                          quote.lender_credits == 0
                          ?
                            null
                          :
                            <li className="lender-fee-item">{quote.lender_credits < 0 ? "Lender credit" : "Discount points"}: {this.formatCurrency(quote.lender_credits)}</li>
                        }
                        {
                          _.map(quote.fees, function(fee){
                            return (
                              <li className="lender-fee-item" key={fee["HudLine"]}>{fee["Description"]}: {this.formatCurrency(fee["FeeAmount"], "$")}</li>
                            )
                          }, this)
                        }
                      </ul>
                      {
                        this.props.helpMeChoose
                        ?
                          <div>
                            <span className="typeLowlight mlm">True Cost of Mortgage: </span>
                            {this.formatCurrency(quote.total_cost, "$")}
                          </div>
                        :
                          null
                      }
                    </div>
                    <div className="col-md-6">
                      <h4>Monthly payment details</h4>
                      <div className="row">
                        <div className="col-md-9">
                          <p className="col-xs-12 cost">Principal and interest</p>
                        </div>
                        <div className="col-md-3">
                          <p className="col-xs-12 cost">{this.formatCurrency(quote.monthly_payment, "$")}</p>
                        </div>
                      </div>
                      {
                        quote.characteristic
                        ?
                          <p className="note">{quote.characteristic}</p>
                        :
                          null
                      }
                    </div>
                  </div>
                  <div className="row chart-part">
                    <div className="col-md-4">
                      <div className="row" style={{marginTop:150}}>
                        <div className="info-board">
                          <table className="table">
                            <thead>
                              <tr>
                                <td><p className="info-label"><span></span>Principal</p></td>
                                <td><p className="info-value text-right" id={"chart-principal" + index}></p></td>
                              </tr>
                              <tr>
                                <td><p className="info-label"><span></span>Interest</p></td>
                                <td><p className="info-value text-right" id={"chart-interest" + index}></p></td>
                              </tr>
                              <tr>
                                <td><p className="info-label"><span></span>Remaining</p></td>
                                <td><p className="info-value text-right" id={"chart-remaining" + index}></p></td>
                              </tr>
                            </thead>
                            <tbody>
                              <tr className="duration-info">
                                <td><p>Duration</p></td>
                                <td><p className="text-right" id={"chart-duration" + index}></p></td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                    <div className="col-md-8">
                      <div id={"linechart" + index} className="line-chart"></div>
                    </div>
                  </div>
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