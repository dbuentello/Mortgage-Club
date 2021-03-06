var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var ListPrograms = require('./List');
var ListQuotes = require('public/InitialQuotes/List');

var yearSlider, avgRateSlider, taxRateSlider;
var expectedMortgageDuration = 9;
var investmentReturnRate = 0.08;
var effectiveTaxRate = 0.2;

var HelpMeChoose = React.createClass({
  mixins: [TextFormatMixin, MortgageCalculatorMixin],

  propTypes: {
    choosePossibleRates: React.PropTypes.func,
  },

  getInitialState: function() {
    var possibleRates = this.choosePossibleRates(9, 0.08, 0.2, true, false);
    return {
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      cashOutCheck: false,
      interestRateCheck: true
    }
  },

  choosePossibleRates: function(periods, avgRate, taxRate, interestRateCheck, cashOutCheck) {
    var totalCost = 0;
    var result;
    var possibleRates = _.sortBy(this.props.programs, function (rate) {
      result = this.totalCost(rate, taxRate, avgRate, periods, this.props.loanPurpose, this.props.mortgageBalance);
      rate['total_cost'] = result['totalCost'];
      rate['result'] = result;
      return rate['total_cost'];
    }.bind(this));

    var possibleRate = [possibleRates[0]];

    if(this.props.loanPurpose == "purchase") {
      var noDownPaymentRate = _.find(possibleRates, function(rate){ return rate.is_down_payment == false; });
      if(noDownPaymentRate !== undefined){
        possibleRates = _.filter(possibleRates, function(rate){
          return rate['down_payment'] >= noDownPaymentRate.down_payment;
        })
      }

      if(interestRateCheck == true) {

      } else {
        possibleRates = _.filter(possibleRates, function(rate){
          return rate['lender_credits'] <= 0;
        })
      }
    } else {
      if(interestRateCheck == true) {
        if(cashOutCheck == true) {

        } else {
          possibleRates = _.filter(possibleRates, function(rate){
            return rate['is_cash_out'] == false;
          })
        }
      } else {
        if(cashOutCheck == true) {
          possibleRates = _.filter(possibleRates, function(rate){
            return rate['lender_credits'] <= 0;
          })
        } else {
          possibleRates = _.filter(possibleRates, function(rate){
            return rate['lender_credits'] <= 0 && rate['is_cash_out'] == false;
          })
        }
      }
    }
    possibleRate = [possibleRates[0]];
    return possibleRate;
  },

  componentDidMount: function() {
    this.buildYearsChart();
    this.buildAverageRatesChart();
    this.buildTaxRatesChart();
  },

  buildTaxRatesChart: function() {
    // build slider
    taxRateSlider = this.generateSliderChart('.tax_rate_chart .slider', 'tax_rect_nth', 0, 50, 1, '.selected_tax_rate .value');
    taxRateSlider.value(20);

    // set default value
    d3.select(".tax_rect_nth20").attr("class", "highlight tax_rect_nth20");
    $('.tax_rate_chart .value').val('20%');
  },

  buildAverageRatesChart: function() {
    // build slider
    avgRateSlider = this.generateSliderChart('.average_rate_chart .slider', 'avg_rect_nth', 0, 30, 1, '.selected_avg_rate .value', 10);
    avgRateSlider.value(8);

    // set default value
    d3.select(".avg_rect_nth18").attr("class", "highlight avg_rect_nth18");
    $('.average_rate_chart .value').val('8%');
  },

  buildYearsChart: function() {
    // build slider
    yearSlider = this.generateSliderChart('.years_chart .slider', 'year_rect_nth', 0, 30, 1, '.selected_year .value');
    yearSlider.value(9);

    // set default value
    d3.select(".year_rect_nth9").attr("class", "highlight year_rect_nth9");
    $('.years_chart .value').val('9 years');
  },

  generateSliderChart: function(selection, rectKlassName, min, max, step, input, normalized_number = 0) {
    var text_display = '';
    // build slider
    var slider = d3.slider().axis(d3.svg.axis().orient("bottom").ticks(4)).min(min).max(max).scale(d3.scale.linear().domain([min, max])).step(step).on('slide', function(event, value) {
      value = Math.ceil(value);
      switch(rectKlassName) {
        case "year_rect_nth":
          text_display = (value > 1) ? (value + " years") : (value + " year");
          expectedMortgageDuration = value;
          break;
        case "avg_rect_nth":
          text_display = value + "%";
          investmentReturnRate = value / 100;
          break;
        case "tax_rect_nth":
          text_display = value + "%";
          effectiveTaxRate = value / 100;
          break;
      }
      $(input).val(text_display);
      for(var i = 0; i <= 50; i++) {
        var klassName = rectKlassName + i;
        d3.select("." + klassName).attr("class", klassName);
      }
      value += normalized_number;
      klassName = rectKlassName + value;
      d3.select("." + klassName).attr("class", "highlight " + klassName);
      var possibleRates = this.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate, this.state.interestRateCheck, this.state.cashOutCheck);
      this.setState({possibleRates: possibleRates, bestRate: possibleRates[0]});
    }.bind(this));
    d3.select(selection).call(slider);
    slider.value(1); // fix the bug of d3.js slider
    return slider;
  },

  onBlur: function(type) {
    var value = 0;
    switch(type) {
      case 'year':
        value = $('.years_chart .value').val();
        value = this.correctValue(value, 'year');
        expectedMortgageDuration = value;
        yearSlider.value(value);
        this.clearHighlightBar('year_rect_nth');
        d3.select(".year_rect_nth" + value).attr("class", "highlight year_rect_nth" + value);
        var postfix = value > 1 ? ' years' : ' year';
        $('.years_chart .value').val(value + postfix)
        break;
      case 'avg_rate':
        value = $('.average_rate_chart .value').val();
        value = this.correctValue(value, 'avg_rate');
        investmentReturnRate = value / 100;
        avgRateSlider.value(value);
        this.clearHighlightBar('avg_rect_nth');
        d3.select(".avg_rect_nth" + (value + 10)).attr("class", "highlight avg_rect_nth" + (value + 10));
        $('.average_rate_chart .value').val(value + '%')
        break;
      case 'tax_rate':
        value = $('.tax_rate_chart .value').val();
        value = this.correctValue(value, 'tax_rate');
        effectiveTaxRate = value / 100;
        taxRateSlider.value(value);
        this.clearHighlightBar('tax_rect_nth');
        d3.select(".tax_rect_nth" + value).attr("class", "highlight tax_rect_nth" + value);
        $('.tax_rate_chart .value').val(value + '%')
        break;
    }
    var possibleRates = this.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate, this.state.interestRateCheck, this.state.cashOutCheck);
    this.setState({possibleRates: possibleRates, bestRate: possibleRates[0]});
  },

  correctValue: function(value, type) {
    value = value.match(/\d+/)[0];
    value = parseInt(value);
    switch(type) {
      case 'year':
        value = value < 0 ? 0 : value;
        value = value > 30 ? 30 : value;
        break;
      case 'avg_rate':
        value = value < 0 ? 0 : value;
        value = value > 30 ? 30 : value;
        break;
      case 'tax_rate':
        value = value < 0 ? 0 : value;
        value = value > 50 ? 50: value;
        break;
    }
    return value;
  },

  clearHighlightBar: function(rectKlassName) {
    for(var i = 0; i <= 50; i++) {
      var klassName = rectKlassName + i;
      d3.select("." + klassName).attr("class", klassName);
    }
  },

  handleInterestRateCheckChange: function(e) {
    var interestRateCheck = this.state.interestRateCheck;
    if($(e.target).val() == "true"){
      interestRateCheck = true;
    } else {
      interestRateCheck = false;
    }

    expectedMortgageDuration = $('.years_chart .value').val();
    expectedMortgageDuration = this.correctValue(expectedMortgageDuration, 'year');

    investmentReturnRate = $('.average_rate_chart .value').val();
    investmentReturnRate = this.correctValue(investmentReturnRate, 'avg_rate') / 100;

    effectiveTaxRate = $('.tax_rate_chart .value').val();
    effectiveTaxRate = this.correctValue(effectiveTaxRate, 'tax_rate') / 100;

    var possibleRates = this.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate, interestRateCheck, this.state.cashOutCheck);

    this.setState({
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      interestRateCheck: interestRateCheck
    });
  },

  handleCashOutCheckChange: function(e) {
    var cashOutCheck = this.state.cashOutCheck;
    if($(e.target).val() == "true"){
      cashOutCheck = true;
    } else {
      cashOutCheck = false;
    }

    expectedMortgageDuration = $('.years_chart .value').val();
    expectedMortgageDuration = this.correctValue(expectedMortgageDuration, 'year');

    investmentReturnRate = $('.average_rate_chart .value').val();
    investmentReturnRate = this.correctValue(investmentReturnRate, 'avg_rate') / 100;

    effectiveTaxRate = $('.tax_rate_chart .value').val();
    effectiveTaxRate = this.correctValue(effectiveTaxRate, 'tax_rate') / 100;

    var possibleRates = this.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate, this.state.interestRateCheck, cashOutCheck);

    this.setState({
      possibleRates: possibleRates,
      bestRate: possibleRates[0],
      cashOutCheck: cashOutCheck
    });
  },

  render: function() {
    return (
      <div>
        <div className="row white-background">
          <div className='row helpmechoose'>
            <div className='col-lg-7 div-back-to-results'>
              <a onClick={this.props.backToRatePage} className="back-to-results"><span>Back to results</span></a>
            </div>
            <div className='col-lg-7 text-xs-justify'>
              <div className='row col-lg-11'>
                Our proprietary True Cost of Mortgage algorithm helps you choose the best mortgage by comparing the future values of total interest paid (adjusted for tax savings) and opportunity costs of both upfront cash to close and mortgage payments for each loan program.
              </div>
            </div>
            <div className='col-lg-7'>
              <div className='row col-lg-11 calculator'>
                <div className='interest_rate_yes_no_question mtxl'>
                  <div className='row'>
                    <div className='col-lg-12'>
                      <h3>Do you want to pay money upfront (aka discount points) to reduce your interest rate?</h3>
                      <p>Paying discount points could save you money if you keep your mortgage past the break-even point (typically 1-2 years).</p>
                    </div>
                  </div>
                  <div className='row calc-form'>
                    <div className='col-lg-12 selected_year col-xs-12'>
                      <div className='control-group mbs'>
                        <label className="radio-inline mbr">
                          <input type="radio" name="interestRateCheck" onChange={this.handleInterestRateCheckChange} checked={this.state.interestRateCheck === true} value="true"/>
                          Yes
                        </label>
                        <label className="radio-inline">
                          <input type="radio" name="interestRateCheck" onChange={this.handleInterestRateCheckChange} checked={this.state.interestRateCheck === false} value="false"/>
                          No
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
                {
                  this.props.loanPurpose == "purchase"
                  ?
                    null
                  :
                    <div className='cash_out_yes_no_question mtxl'>
                      <div className='row'>
                        <div className='col-lg-12'>
                          <h3>Do you want to cash out?</h3>
                          <p>With interest rates near all-time low, cash out refinancing is a smart choice if you use the proceeds for higher yield investments.</p>
                        </div>
                      </div>
                      <div className='row calc-form'>
                        <div className='col-lg-12 col-xs-12'>
                          <div className='control-group mbs'>
                            <label className="radio-inline mbr">
                              <input type="radio" name="cashOutCheck" onChange={this.handleCashOutCheckChange} checked={this.state.cashOutCheck === true} value="true"/>
                              Yes
                            </label>
                            <label className="radio-inline">
                              <input type="radio" name="cashOutCheck" onChange={this.handleCashOutCheckChange} checked={this.state.cashOutCheck === false} value="false"/>
                              No
                            </label>
                          </div>
                        </div>
                      </div>
                    </div>
                }
                <div className='years_chart mtxl'>
                  <div className='row'>
                    <div className='col-lg-12'>
                      <h3>How long do you plan to stay?</h3>
                      <p>30-year fixed mortgage tends to be better the longer you stay because interest rates are likely to rise gradually over the next several years.</p>
                    </div>
                  </div>
                  <div className='row calc-form'>
                    <div className='col-lg-2 selected_year col-xs-12'>
                      <input className="value" onBlur={_.bind(this.onBlur, null, 'year')}/>
                    </div>
                    <div className='col-lg-10 range col-xs-12 slider-item'>
                      <div className='slider'></div>
                    </div>
                  </div>
                </div>
                <div className='average_rate_chart mtxl'>
                  <div className= 'row'>
                    <div className='col-lg-12'>
                      <h3>{"What's your average rate of return on your personal investments?"}</h3>
                      <p>You might be better off spending less money upfront on your mortgage and invest the cash elsewhere.</p>
                    </div>
                  </div>
                  <div className='row calc-form'>
                    <div className='col-lg-2 selected_avg_rate col-xs-12'>
                      <input className="value" onBlur={_.bind(this.onBlur, null, 'avg_rate')}/>
                    </div>
                    <div className='col-lg-10 range col-xs-12 slider-item'>
                      <div className='slider'></div>
                    </div>
                  </div>
                </div>
                <div className='tax_rate_chart mtxl'>
                  <div className= 'row'>
                    <div className='col-lg-12'>
                      <h3>Your combined federal and state income tax rate</h3>
                    </div>
                  </div>
                  <div className='row calc-form'>
                    <div className='col-lg-2 selected_tax_rate col-xs-12'>
                      <input className="value" onBlur={_.bind(this.onBlur, null, 'tax_rate')}/>
                    </div>
                    <div className='col-lg-10 range col-xs-12 slider-item'>
                      <div className='slider'></div>
                    </div>
                  </div>
                </div>
                <br ></br>
                <br ></br>
              </div>
            </div>
            {
              this.state.bestRate ?
              <div className='col-lg-5 best-rate'>
                <div className='row'>
                  <h1>Your Best Option</h1>
                </div>
                <div className='row bankname'>
                  <h2>{this.state.bestRate.lender_name}</h2>
                </div>
                <div className='row monthly-payment'>
                  <b className='value'>{this.formatCurrency(this.state.bestRate.monthly_payment, 0, '$')}</b>
                  <div className="primary-cost-unit">PER<br/>MONTH</div>
                </div>
                <div className='row secondary-cost'>
                  <div className='col-xs-6 col-md-6'>
                    NMLS
                  </div>
                  <div className='col-xs-6 col-md-6'>
                    {this.state.bestRate.nmls}
                  </div>
                </div>
                <div className='row secondary-cost'>
                  <div className='col-xs-6 col-md-6'>
                    Loan Type
                  </div>
                  <div className='col-xs-6 col-md-6'>
                    {this.state.bestRate.product}
                  </div>
                </div>
                {
                  this.props.loanPurpose == "purchase"
                  ?
                    <div className='row secondary-cost'>
                      <div className='col-xs-6 col-md-6'>
                        Down Payment
                      </div>
                      <div className='col-xs-6 col-md-6'>
                        {this.formatCurrency(this.state.bestRate.down_payment, 0, '$')}
                      </div>
                    </div>
                  :
                    <div className='row secondary-cost'>
                      <div className='col-xs-6 col-md-6'>
                        Cash Out
                      </div>
                      <div className='col-xs-6 col-md-6'>
                        {
                          Math.abs(this.state.bestRate.loan_amount - this.props.mortgageBalance) >= 0 && Math.abs(this.state.bestRate.loan_amount - this.props.mortgageBalance) < 0.5
                          ?
                            "$0"
                          :
                            this.formatCurrency(this.state.bestRate.loan_amount - this.props.mortgageBalance, 0, '$')
                        }
                      </div>
                    </div>
                }
                <div className='row secondary-cost'>
                  <div className='col-xs-6 col-md-6'>
                    Rate
                  </div>
                  <div className='col-xs-6 col-md-6'>
                    {this.commafy(this.state.bestRate.interest_rate * 100, 3)}%
                  </div>
                </div>
                {
                  this.state.bestRate.lender_credits == 0
                  ?
                    null
                  :
                    <div className='row secondary-cost'>
                      <div className='col-xs-6 col-md-6'>
                        {this.state.bestRate.lender_credits < 0 ? "Lender Credit" : "Discount Points"}
                      </div>
                      <div className='col-xs-6 col-md-6'>
                        {this.formatCurrency(this.state.bestRate.lender_credits, 0, "$")}
                      </div>
                    </div>
                }
                <div className='row secondary-cost'>
                  <div className='col-xs-6 col-md-6'>
                    Closing Costs
                  </div>
                  <div className='col-xs-6 col-md-6'>
                    {this.formatCurrency(this.state.bestRate.total_closing_cost, 0, '$')}
                  </div>
                </div>
                <div className='row secondary-cost' style={{"fontWeight": "bold"}}>
                  <div className='col-xs-6 col-md-6'>
                    True Cost of Mortgage
                  </div>
                  <div className='col-xs-6 col-md-6'>
                    {this.formatCurrency(this.state.bestRate.total_cost, 0, '$')}
                  </div>
                </div>
                <div className='row text-xs-center'>
                  {
                    this.state.bestRate.lender_name == "Wells Fargo"
                    ?
                      <a className='btn btnLrg mtm select-btn col-sm-offset-4' target="_blank" href="https://www.wellsfargo.com/mortgage/">
                        Go To Wells Fargo
                      </a>
                    :
                      <a className='btn btnLrg mtm select-btn col-sm-offset-4' onClick={_.bind(this.props.selectRate, null, this.state.bestRate)}>
                        {this.props.isInitialQuotes ? "Apply Now" : "Select"}
                      </a>
                  }
                </div>
              </div>
            : null
            }
          </div>
        </div>

        <div className="col-xs-12 account-content padding-left-55 custom-left-mortgage-rates">
          <div id="mortgagePrograms">
            {
              this.props.isInitialQuotes
              ?
                <ListQuotes quotes={this.state.possibleRates} selectRate={this.props.selectRate} helpMeChoose={true} monthlyPayment={this.props.monthlyPayment}/>
              :
                <ListPrograms loanAmount={this.props.loan.amount} programs={this.state.possibleRates} subjectProperty={this.props.loan.subject_property} selectRate={this.props.selectRate} helpMeChoose={true}/>
            }
          </div>
        </div>
      </div>
    )
  }
});

module.exports = HelpMeChoose;