var _ = require('lodash');
var React = require('react/addons');
var Navigation = require('react-router').Navigation;

var LoaderMixin = require('mixins/LoaderMixin');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var MortgageRates = React.createClass({
  mixins: [LoaderMixin, ObjectHelperMixin, TextFormatMixin, Navigation],

  getInitialState: function() {
    return {
      rates: this.props.bootstrapData.rates
    }
  },

  onSelect: function(rate) {
    location.href = '/esigning/' + this.props.bootstrapData.currentLoan.id;
  },

  componentDidMount: function() {
    this.buildYearsChart();
    this.buildAverageRatesChart();
    this.buildTaxRatesChart();
  },

  buildTaxRatesChart: function() {
    // build slider
    this.generateSliderChart('.tax_rate_chart .slider', 'tax_rect_nth', 6, 0, 50, 1, '.selected_tax_rate .value');

    // build bar chart
    var rates = [];
    for(var i = 1; i <= 50; i++) {
      rates.push(i);
    }
    this.generateBarChart(rates, ".tax_rate_chart .bar_chart", "tax_rect_nth");
  },

  buildAverageRatesChart: function() {
    // build slider
    this.generateSliderChart('.average_rate_chart .slider', 'avg_rect_nth', 6, -10, 20, 1, '.selected_avg_rate .value', 10);

    // build bar chart
    var rates = [];
    for(var i = 1; i <= 30; i++) {
      rates.push(i);
    }
    this.generateBarChart(rates, ".average_rate_chart .bar_chart", "avg_rect_nth");
  },

  buildYearsChart: function() {
    // build slider
    this.generateSliderChart('.years_chart .slider', 'year_rect_nth', 4, 0, 40, 1, '.selected_year .value');
    // build bar chart
    var years = [];
    for(var i = 1; i <= 40; i++) {
      years.push(i);
    }
    this.generateBarChart(years, ".years_chart .bar_chart", "year_rect_nth");
  },

  generateSliderChart: function(selection, rectKlassName, tick, min, max, step, input, normalized_number = 0) {
    // build slider
    var slider = d3.slider().axis(d3.svg.axis().orient("bottom").ticks(tick)).min(min).max(max).step(step).on('slide', function(event, value) {
      $(input).text(value);
      for(var i = 0; i <= 50; i++) {
        var klassName = rectKlassName + i;
        d3.select("." + klassName).attr("class", klassName);
      }
      value += normalized_number
      klassName = rectKlassName + value;
      d3.select("." + klassName).attr("class", "highlight " + klassName);
    });
    d3.select(selection).call(slider);
  },

  generateBarChart: function(data, selection, rectKlassName) {
    var width = 760,
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

  onSelect: function(rate) {
  },

  render: function() {
    // if (!this.state.loaded) {
    //   return (
    //     <div className='content container text-center'>
    //       {this.renderLoader()}
    //     </div>
    //   );
    // }

    return (
      <div className='content container mortgage-rates'>
        <div className='charts'>
          <div className='years_chart mtxl'>
            <div className='row'>
              <div className='col-xs-2 ptxl selected_year'>
                <span className='value'>0</span>
                <span className='postfix'> years</span>
              </div>
              <div className='col-xs-9'>
                <svg className='bar_chart'></svg>
                <div className='slider'></div>
              </div>
            </div>
          </div>
          <div className='average_rate_chart mtxl'>
            <div className='row'>
              <div className='col-xs-2 ptxl selected_avg_rate'>
                <span className='value'>0</span>
                <span className='postfix'>%</span>
              </div>
              <div className='col-xs-9'>
                <svg className='bar_chart'></svg>
                <div className='slider'></div>
              </div>
            </div>
          </div>
          <div className='tax_rate_chart mtxl'>
            <div className='row'>
              <div className='col-xs-2 ptxl selected_tax_rate'>
                <span className='value'>0</span>
                <span className='postfix'>%</span>
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
