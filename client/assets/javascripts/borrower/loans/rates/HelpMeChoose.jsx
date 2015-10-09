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
    chooseBestRates: React.PropTypes.func,
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
    $('.slider').css('width', '765px');
  },

  buildTaxRatesChart: function() {
    // build slider
    taxRateSlider = this.generateSliderChart('.tax_rate_chart .slider', 'tax_rect_nth', 0, 50, 1, '.selected_tax_rate .value');
    taxRateSlider.value(20);

    // build bar chart
    var rates = [];
    for(var i = 0; i <= 50; i++) {
      rates.push(i);
    }
    this.generateBarChart(rates, ".tax_rate_chart .bar_chart", "tax_rect_nth");

    // set default value
    d3.select(".tax_rect_nth20").attr("class", "highlight tax_rect_nth20");
    $('.tax_rate_chart .value').val('20%');
  },

  buildAverageRatesChart: function() {
    // build slider
    avgRateSlider = this.generateSliderChart('.average_rate_chart .slider', 'avg_rect_nth', -10, 20, 1, '.selected_avg_rate .value', 10);
    avgRateSlider.value(8);

    // build bar chart
    var rates = [];
    for(var i = 0; i <= 30; i++) {
      rates.push(i);
    }
    this.generateBarChart(rates, ".average_rate_chart .bar_chart", "avg_rect_nth");

    // set default value
    d3.select(".avg_rect_nth18").attr("class", "highlight avg_rect_nth18");
    $('.average_rate_chart .value').val('8%');
  },

  buildYearsChart: function() {
    // build slider
    yearSlider = this.generateSliderChart('.years_chart .slider', 'year_rect_nth', 0, 30, 1, '.selected_year .value');
    yearSlider.value(9);

    // build bar chart
    var years = [];
    for(var i = 0; i <= 30; i++) {
      years.push(i);
    }
    this.generateBarChart(years, ".years_chart .bar_chart", "year_rect_nth");

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
      this.props.chooseBestRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate);
    }.bind(this));
    d3.select(selection).call(slider);
    slider.value(1); // fix the bug of d3.js slider
    return slider;
  },

  generateBarChart: function(data, selection, rectKlassName) {
    var width = 765,
        height = 100;

    var y = d3.scale.linear().range([height, 0]);

    var chart = d3.select(selection)
      .attr("width", width)
      .attr("height", height);

    y.domain([0, d3.max(data, function(d) { return d; })]);

    var barWidth = width / data.length;

    var bar = chart.selectAll("g")
        .data(data)
      .enter().append("g")
        .attr("transform", function(d, i) { return "translate(" + i * barWidth + ",0)"; });

    bar.append("rect")
        .attr("y", function(d) { return y(d); })
        .attr("height", function(d) { return height - y(d); })
        .attr("width", barWidth - 1)
        .attr("class", function(d) { return rectKlassName + d });
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
    this.props.chooseBestRates(expectedMortgageDuration, investmentReturnRate, effectiveTaxRate);
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
        value = value < -10 ? -10 : value;
        value = value > 20 ? 20 : value;
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
      <div className='charts'>
        <div className='years_chart mtxl'>
          <div className= 'row'>
            <h3>How Long Do You Plan To Stay?</h3>
            <p>Buying tends to be better the longer you stay because the upfront fees are spread out over many years</p>
          </div>
          <div className='row'>
            <div className='col-xs-2 selected_year'>
              <input className="value" onBlur={_.bind(this.onBlur, null, 'year')}/>
            </div>
            <div className='col-xs-9'>
              <svg className='bar_chart'></svg>
              <div className='slider'></div>
            </div>
            <div className='col-xs-1'>
              <a className='btn btnSml btnAction' onClick={this.props.helpMeChoose}>Back to rates</a>
            </div>
          </div>
        </div>
        <div className='average_rate_chart mtxl'>
          <div className= 'row'>
            <h3>{"What's your average rate of return on your personal investments?"}</h3>
          </div>
          <div className='row'>
            <div className='col-xs-2 selected_avg_rate'>
              <input className="value" onBlur={_.bind(this.onBlur, null, 'avg_rate')}/>
              <p>Investment return rate</p>
            </div>
            <div className='col-xs-9'>
              <svg className='bar_chart'></svg>
              <div className='slider'></div>
            </div>
          </div>
        </div>
        <div className='tax_rate_chart mtxl'>
          <div className= 'row'>
            <div className='col-xs-4'>
              <h3>How do you file your taxes:</h3>
            </div>
            <div className='col-xs-6 mtm'>
              <div className="control-group mbs">
                <label className="radio-inline mrm">
                  <input type="radio" value='true' onChange={this.onChange}/>
                  Individual Return
                </label>
                <label className="radio-inline">
                  <input type="radio" value='false' onChange={this.onChange}/>
                  Joint Return
                </label>
              </div>
            </div>
          </div>
          <div className='row'>
            <div className='col-xs-2 selected_tax_rate'>
              <input className="value" onBlur={_.bind(this.onBlur, null, 'tax_rate')}/>
              <p>Marginal tax rate</p>
            </div>
            <div className='col-xs-9'>
              <svg className='bar_chart'></svg>
              <div className='slider'></div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = HelpMeChoose;