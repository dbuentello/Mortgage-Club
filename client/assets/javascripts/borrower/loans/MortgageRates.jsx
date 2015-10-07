var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var yearSlider, avgRateSlider, taxRateSlider;

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation, MortgageCalculatorMixin],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates,
      expectedMortgageDuration: 20,
      effectiveTaxRate: 0.08,
      investmentReturnRate: 0.2,
      helpMeChoose: false
    }
  },

  onSelect: function(rate) {
    console.dir(rate['fees'])
    // location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
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
      switch(rectKlassName){
        case "year_rect_nth":
          text_display = (value > 1) ? (value + " years") : (value + " year");
          this.setState({'expectedMortgageDuration': value});
          break;
        case "avg_rect_nth":
          text_display = value + "%";
          this.setState({'investmentReturnRate': (value / 100)});
          break;
        case "tax_rect_nth":
          text_display = value + "%";
          this.setState({'effectiveTaxRate': (value / 100)});
          break;
      }
      $(input).val(text_display);
      for(var i = 0; i <= 50; i++) {
        var klassName = rectKlassName + i;
        d3.select("." + klassName).attr("class", klassName);
      }
      value += normalized_number
      klassName = rectKlassName + value;
      d3.select("." + klassName).attr("class", "highlight " + klassName);

      this.helpMeChoose();
    }.bind(this));
    d3.select(selection).call(slider);
    slider.value(1); // fix the bug of d3.js slider
    return slider;
  },

  generateBarChart: function(data, selection, rectKlassName) {
    var width = 764,
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
        this.setState({'expectedMortgageDuration': value});
        yearSlider.value(value);
        this.clearHighlightBar('year_rect_nth');
        d3.select(".year_rect_nth" + value).attr("class", "highlight year_rect_nth" + value);
        var postfix = value > 1 ? ' years' : ' year';
        $('.years_chart .value').val(value + postfix)
        break;
      case 'avg_rate':
        value = $('.average_rate_chart .value').val();
        value = this.correctValue(value, 'avg_rate');
        this.setState({'investmentReturnRate': (value / 100)});
        avgRateSlider.value(value);
        this.clearHighlightBar('avg_rect_nth');
        d3.select(".avg_rect_nth" + (value + 10)).attr("class", "highlight avg_rect_nth" + (value + 10));
        $('.average_rate_chart .value').val(value + '%')
        break;
      case 'tax_rate':
        value = $('.tax_rate_chart .value').val();
        value = this.correctValue(value, 'tax_rate');
        this.setState({'effectiveTaxRate': (value / 100)});
        taxRateSlider.value(value);
        this.clearHighlightBar('tax_rect_nth');
        d3.select(".tax_rect_nth" + value).attr("class", "highlight tax_rect_nth" + value);
        $('.tax_rate_chart .value').val(value + '%')
        break;
    }
    this.helpMeChoose();
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

  helpMeChoose: function() {
    var sortedRates = _.sortBy(this.state.rates, function (rate) {
      var totalCost = this.totalCost(rate, this.state.effectiveTaxRate, this.state.investmentReturnRate, this.state.expectedMortgageDuration);
      rate['total_cost'] = totalCost;
      return totalCost;
    }.bind(this));
    this.setState({
      sortedRates: sortedRates,
      helpMeChoose: true
    });
  },

  render: function() {
    return (
      <div className='content container mortgage-rates'>
        <div className='charts'>
          <div className='years_chart mtxl'>
            <div className= 'row'>
              <h3>How Long Do You Plan To Stay?</h3>
              <p>Buying tends to be better the longer you stay because the upfront fees are spread out over many years</p>
            </div>
            <div className='row'>
              <div className='col-xs-2 selected_year'>
                <input className="value" onChange={this.onChange} onBlur={_.bind(this.onBlur, null, 'year')}/>
              </div>
              <div className='col-xs-9'>
                <svg className='bar_chart'></svg>
                <div className='slider'></div>
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
              <h3>How do you file your taxes:</h3>
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
        <div className='row mtl'>
          <div className='col-sm-6'>
            <span className='typeLowlight'>Sort by:</span>
            <a className='clickable mlm' onClick={_.bind(this.sortBy, null, 'apr')}>APR</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'pmt')}>Monthly Payment</a>
            <a className='clickable mll' onClick={_.bind(this.sortBy, null, 'rate')}>Rate</a>
          </div>
          <div className='col-sm-6 text-right'>
            <a className='btn btnSml btnAction'>Help me choose</a>
          </div>
        </div>
        this.state.helpMeChoose ?
          {_.map(this.state.sortedRates, function (rate, index) {
            return (
              <div key={index} className={'row mhn roundedCorners bas mvm pvm' + (index % 2 === 0 ? ' backgroundLowlight' : '')}>
                <div className='col-sm-3'>
                  <div className='typeBold'>{rate.lender_name}</div>
                  Logo
                  <div>
                    <span className='typeLowlight'>NMLS: </span>{rate.nmls}
                  </div>
                </div>
                <div className='col-sm-6'>
                  {rate.product}<br/>
                  {this.commafy(rate.apr, 3)}% APR
                  <span className='typeLowlight mlm'>Monthly Payment: </span>
                  {this.formatCurrency(rate.monthly_payment, '$')}<br/>
                  <span className='typeLowlight'>Rate: </span>{this.commafy(rate.interest_rate, 3)}%
                  <span className='typeLowlight mlm'>Total Closing Cost: </span>
                  {this.formatCurrency(rate.total_fee, '$')}
                  <span className='typeLowlight mlm'>Total Cost: </span>
                  {this.formatCurrency(rate.total_cost, '$')}
                </div>
                <div className='col-sm-3 pull-right text-right'>
                  <a className='btn btm Sml btnPrimary' onClick={_.bind(this.onSelect, null, rate)}>Select</a>
                </div>
              </div>
            );
          }, this)}
        :
          {_.map(this.state.rates, function (rate, index) {
            return (
              <div key={index} className={'row mhn roundedCorners bas mvm pvm' + (index % 2 === 0 ? ' backgroundLowlight' : '')}>
                <div className='col-sm-3'>
                  <div className='typeBold'>{rate.lender_name}</div>
                  Logo
                  <div>
                    <span className='typeLowlight'>NMLS: </span>{rate.nmls}
                  </div>
                </div>
                <div className='col-sm-6'>
                  {rate.product}<br/>
                  {this.commafy(rate.apr, 3)}% APR
                  <span className='typeLowlight mlm'>Monthly Payment: </span>
                  {this.formatCurrency(rate.monthly_payment, '$')}<br/>
                  <span className='typeLowlight'>Rate: </span>{this.commafy(rate.interest_rate, 3)}%
                  <span className='typeLowlight mlm'>Total Closing Cost: </span>
                  {this.formatCurrency(rate.total_fee, '$')}
                </div>
                <div className='col-sm-3 pull-right text-right'>
                  <a className='btn btm Sml btnPrimary' onClick={_.bind(this.onSelect, null, rate)}>Select</a>
                </div>
              </div>
            );
          }, this)}
      </div>
    );
  },

  sortBy: function(field) {
    if (field == 'apr') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.apr);
      })});
    } else if (field == 'pmt') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.monthly_payment);
      })});
    } else if (field == 'rate') {
      this.setState({rates: _.sortBy(this.state.rates, function (rate) {
        return parseFloat(rate.interest_rate);
      })});
    }
  }
});

module.exports = MortgageRates;
