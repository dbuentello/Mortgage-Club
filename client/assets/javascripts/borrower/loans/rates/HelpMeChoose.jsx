var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var yearSlider, avgRateSlider, taxRateSlider;
var expectedMortgageDuration = 9;
var investmentReturnRate = 0.08;
var effectiveTaxRate = 0.2;
var HelpMeChoose = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    choosePossibleRates: React.PropTypes.func,
  },

  getInitialState: function() {
    return {
      helpMeChoose: false
    }
  },

  componentDidMount: function() {
    this.buildYearsChart();
    this.buildAverageRatesChart();
    this.buildTaxRatesChart();
    this.props.choosePossibleRates(9, 0.08, 0.2);
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
      this.props.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate);
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
    this.props.choosePossibleRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate);
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

  render: function() {
    return (
      <div className="row white-background">
        <div className='row helpmechoose'>
          <div className='col-lg-7'>
            <div className='col-lg-11 calculator'>
              <div className='years_chart mtxl'>
                <div className='row'>
                  <div className='col-lg-12'>
                    <h3>How Long Do You Plan To Stay?</h3>
                    <p>30-year fixed mortgage tends to be better the longer you stay because interest rates are likely to rise gradually over the next several years.</p>
                  </div>
                </div>
                <div className='row calc-form'>
                  <div className='col-lg-2 selected_year'>
                    <input className="value" onBlur={_.bind(this.onBlur, null, 'year')}/>
                  </div>
                  <div className='col-lg-9 range'>
                    <div className='slider'></div>
                  </div>
                </div>
              </div>
              <div className='average_rate_chart mtxl'>
                <div className= 'row'>
                  <div className='col-lg-12'>
                    <h3>{"What's your average rate of return on your personal investments?"}</h3>
                    <p>You might be better off spending less money upfront on your mortgage and invest the cash elsewhre.</p>
                  </div>
                </div>
                <div className='row calc-form'>
                  <div className='col-lg-2 selected_avg_rate'>
                    <input className="value" onBlur={_.bind(this.onBlur, null, 'avg_rate')}/>
                    <p>Investment return rate</p>
                  </div>
                  <div className='col-lg-9 range'>
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
                  <div className='col-lg-2 selected_tax_rate'>
                    <input className="value" onBlur={_.bind(this.onBlur, null, 'tax_rate')}/>
                    <p>Effective tax rate</p>
                  </div>
                  <div className='col-lg-9 range'>
                    <div className='slider'></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          {
            this.props.bestRate ?
            <div className='col-lg-5 best-rate'>
              <div className='row'>
                <h1>Your Best Option</h1>
              </div>
              <div className='row bankname'>
                <h2>{this.props.bestRate.lender_name}</h2>
              </div>
              <div className='row monthly-payment'>
                <b className='value'>{this.formatCurrency(this.props.bestRate.monthly_payment, '$')}</b>
                <div className="primary-cost-unit">PER<br/>MONTH</div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  NMLS
                </div>
                <div className='col-lg-6'>
                  {this.props.bestRate.nmls}
                </div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  Loan type
                </div>
                <div className='col-lg-6'>
                  {this.props.bestRate.product}
                </div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  Rate
                </div>
                <div className='col-lg-6'>
                  {this.commafy(this.props.bestRate.interest_rate * 100, 3)}%
                </div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  APR
                </div>
                <div className='col-lg-6'>
                  {this.commafy(this.props.bestRate.apr, 3)}%
                </div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  Total Closing Cost
                </div>
                <div className='col-lg-6'>
                  {this.formatCurrency(this.props.bestRate.total_fee, '$')}
                </div>
              </div>
              <div className='row secondary-cost'>
                <div className='col-lg-6'>
                  True Cost of Mortgage
                </div>
                <div className='col-lg-6'>
                  {this.formatCurrency(this.props.bestRate.total_cost, '$')}
                </div>
              </div>
              <div className='row'>
                <a className='btn btnLrg mtm select-btn col-sm-offset-4' onClick={_.bind(this.props.selectRate, null, this.props.bestRate)}>Select</a>
              </div>
            </div>
          : null
          }

        </div>
      </div>
    )
  }
});

module.exports = HelpMeChoose;