var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var Chart = React.createClass({
  mixins: [TextFormatMixin],

  render: function() {
    return (
      <div className="row chart-part">
        <div className="col-md-4">
          <div id={"piechart" + this.props.id} className="pie-chart"></div>
        </div>
        <div className="col-md-8">
          <div id={"linechart" + this.props.id}></div>
        </div>
      </div>
    )
  },

  componentDidMount: function() {
    this.drawPieChart();
  },

  drawPieChart: function(){
    var color = d3.scale.category20c();

    var dataset = [
      { label: 'P&I', count: this.props.principle },
      { label: 'Insurance', count: this.props.hazardInsurance },
      { label: 'Taxes', count: this.props.propertyTax }
    ];

    if (this.props.mortgageInsurance !== undefined && this.props.mortgageInsurance !== null && this.props.mortgageInsurance !== 0){
      dataset.push({label: "H&I", count: this.props.mortgageInsurance})
    }

    if (this.props.hoadue !== undefined && this.props.hoadue !== null && this.props.hoadue !== 0){
      dataset.push({label: "HOA Due", count: this.props.hoadue})
    }

    var data = [dataset];

    var pieContainer = $("#piechart" + this.props.id);
    var pieWidth = pieContainer.width();
    var pieHeight = pieWidth;
    var radius = pieWidth*.274;//60
    var donutWidth = radius*.4;//24

    var arc = d3.svg.arc()
      .innerRadius(radius - donutWidth)
      .outerRadius(radius);

    var pie = d3.layout.pie()
      .value(function(d) { return d.count; })
      .sort(null);

    var svg = d3.select("#piechart" + this.props.id)
      .append('svg')
      .attr('width', pieWidth)
      .attr('height', pieHeight)
      .append('g')
      .attr('transform', 'translate(' + (pieWidth / 2) +
        ',' + (pieHeight / 2) + ')');

    var path = svg.selectAll('g.slice')
      .data(pie(data[0]))
      .enter()
      .append('g')
      .attr('class','slice');
      //.attr('d', arc);

    path.append('path').attr('d', arc).attr("fill", function(d, i){
      return color(i);
    });

      // Add a legendLabel to each arc slice...
    var pieText = path.append("svg:text");

    pieText.append('tspan').attr('x',0).attr('dy','1.2em').text(function(d, j) { return data[0][j].label; });
    pieText.append('tspan').attr('x',0).attr('dy','1.2em').text(function(d, j) { return (data[0][j].count<1000) ? "$" + data[0][j].count : ("$" + Math.floor(data[0][j].count/1000) + ',' + data[0][j].count%1000); });

    pieText.attr("transform", function(d) { //set the label's origin to the center of the arc
     //we have to make sure to set these before calling arc.centroid
      var textHeight = 33;

      var c = arc.centroid(d),
        x = c[0],
        y = c[1],
        // pythagorean theorem for hypotenuse
        h = Math.sqrt(x*x + y*y);
      return "translate(" + (x/h * 85/60 * radius) +  ',' + (y/h * 85/60 * radius - textHeight/2) +  ")";
    }).attr("text-anchor", "middle");
  },

  drawLineChart: function(){

  }
});

module.exports = Chart;
