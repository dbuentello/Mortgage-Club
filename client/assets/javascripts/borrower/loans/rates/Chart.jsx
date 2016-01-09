var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var MortgageCalculatorMixin = require('mixins/MortgageCalculatorMixin');
var ChartMixin = require('mixins/ChartMixin');

var Chart = React.createClass({
  mixins: [TextFormatMixin, MortgageCalculatorMixin, ChartMixin],

  render: function() {
    return (
      <div className="row chart-part">
        <div className="col-md-4">
          <div id={"piechart" + this.props.id} className="pie-chart">
          </div>
        </div>
        <div className="col-md-8">
          <div id={"linechart" + this.props.id} className="line-chart"></div>
        </div>
      </div>
    )
  },

  componentDidMount: function() {
    if(this.props.id == 0){
      this.drawPie();
      this.drawLine();
    }
  },

  drawPie: function(){
    this.drawPieChart(this.props.id, this.props.principle, this.props.hazardInsurance, this.props.propertyTax, this.props.mortgageInsurance, this.props.hoadue, this.props.total);
  },

  drawLine: function(){
    this.drawLineChart(this.props.id, this.props.numOfMonths, parseInt(this.props.loanAmount), this.props.interestRate, this.props.principle);
  }
});

module.exports = Chart;
