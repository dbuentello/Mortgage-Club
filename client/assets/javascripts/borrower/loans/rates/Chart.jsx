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
          <div className="row">
            <div id={"piechart" + this.props.id} className="pie-chart"></div>
          </div>
          <div className="row">
            <div className="info-board">
              <table className="table">
                <thead>
                  <tr>
                    <td><p className="info-label"><span></span>Principal</p></td>
                    <td><p className="info-value text-right" id={"chart-principal" + this.props.id}></p></td>
                  </tr>
                  <tr>
                    <td><p className="info-label"><span></span>Interest</p></td>
                    <td><p className="info-value text-right" id={"chart-interest" + this.props.id}></p></td>
                  </tr>
                  <tr>
                    <td><p className="info-label"><span></span>Remaining</p></td>
                    <td><p className="info-value text-right" id={"chart-remaining" + this.props.id}></p></td>
                  </tr>
                </thead>
                <tbody>
                  <tr className="duration-info">
                    <td><p>Duration</p></td>
                    <td><p className="text-right" id={"chart-duration" + this.props.id}></p></td>
                  </tr>
                </tbody>
              </table>
            </div>
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
