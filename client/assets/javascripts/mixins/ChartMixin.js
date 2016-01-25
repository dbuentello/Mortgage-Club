var TextFormat = require("mixins/TextFormatMixin")
var ChartMixin = {

  drawPieChart: function(id, principal, hazardInsurance, propertyTax, mortgageInsurance, hoadue, totalMontlyPayment) {
    $("#piechart" + id).append("<p class='piechart-center'>Your payment<br/>$" + totalMontlyPayment + "</p>");
    principal = parseFloat(principal);
    hazardInsurance = parseFloat(hazardInsurance);
    propertyTax = parseFloat(propertyTax);

    var dataset = [
      { label: 'P&I', count: principal },
      { label: 'Insurance', count: hazardInsurance },
      { label: 'Taxes', count: propertyTax }
    ];

    if (mortgageInsurance !== undefined && mortgageInsurance !== null && mortgageInsurance !== 0){
      mortgageInsurance = parseFloat(mortgageInsurance);
      dataset.push({label: "H&I", count: mortgageInsurance})
    }

    if (hoadue !== undefined && hoadue !== null && hoadue !== 0){
      hoadue = parseFloat(hoadue);
      dataset.push({label: "HOA Due", count: hoadue})
    }

    var color = d3.scale.category20c();
    var data = [dataset];

    var pieContainer = $("#piechart" + id);
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

    var svg = d3.select("#piechart" + id)
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

    path.append('path')
      .attr('d', arc)
      .style("stroke", "#fff")
      .style("stroke-width", "2")
      .style("fill-rule", "evenodd")
      .style("fill", function(d, i) { return color(data[0][i].label); });


      // Add a legendLabel to each arc slice...
    var pieText = path.append("svg:text");

    pieText.append('tspan')
      .attr('x',0)
      .attr('dy','1.2em')
      .style("font-size", "0.8em")
      .text(function(d, j) {
        return data[0][j].label;
      });

    pieText.append('tspan')
      .attr('x',0)
      .attr('dy','1.2em')
      .style("font-size", "1.1em")
      .text(function(d, j) {
        return TextFormat.formatCurrency(data[0][j].count);
      });

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

    pieText.style("fill", "#14c0f0").style("transform-origin", "50% 50%");

    $("#piechart" + id).append('<p></p>');
  },

  totalInterestPaid1: function(amount, rate, expectedMortgageDuration, monthlyPayment) {
    var monthlyInterestRate = rate / 12;
    var totalInterest = 0;
    expectedMortgageDuration = expectedMortgageDuration * 12;

    for(var i = 1; i <= expectedMortgageDuration; i++) {
      interestPayment = Math.round(amount * monthlyInterestRate * 100) / 100;
      principalPayment = monthlyPayment - interestPayment;
      amount -= principalPayment;
      totalInterest += interestPayment;
    }
    return Math.round(totalInterest * 100) / 100;
  },

  mortgageCalculation: function(numOfMonths, loanAmount, interestRate, monthlyPayment){
    var interests = [];
    var principals = [];
    var remainings = [];

    for(var i = 0; i <= numOfMonths; i++){
      var interest = this.totalInterestPaid1(loanAmount, interestRate, i/12, monthlyPayment);
      var principal = monthlyPayment * i - interest;
      var remaining = loanAmount - principal;

      interests.push({month: i, amount: Math.floor(interest)});
      principals.push({month: i, amount: Math.floor(principal)});
      remainings.push({month: i, amount: Math.floor(remaining)});
    }
    return [interests, principals, remainings];
  },

  drawLineChart: function(id, numOfMonths, loanAmount, interestRate, monthlyPayment) {
    var colors = ["#ff7575", "#00bc9c", "#14c0f0"];

    var data = this.mortgageCalculation(numOfMonths, loanAmount, interestRate, monthlyPayment);

    var allData = [data];

    var chartContainer = $('#linechart' + id);

    var chartWidth = chartContainer.width();
    var chartHeight = 320;
    var marginRight = 45;
    var marginBottom = 30;

    var xScale = d3.scale.linear()
      .range([0, chartWidth - marginRight]).domain([0, numOfMonths]);

    var yScale = d3.scale.linear()
      .range([0, chartHeight - marginBottom]).domain([loanAmount, 0]);

    var xAxis = d3.svg.axis().scale(xScale)
      .tickValues([0, numOfMonths / 3, numOfMonths / 3 * 2, numOfMonths])
      .orient('bottom')
      .tickPadding(10)
      .innerTickSize(0)
      .outerTickSize(0)
      .tickFormat(function(d, i) {
        if (i == 0 || i == 3)
          return "";
        return d + "mo";
      });

    var yAxis = d3.svg.axis().scale(yScale).ticks(4)
      .orient('left')
      .tickPadding(20)
      .outerTickSize(0)
      .innerTickSize(marginRight-chartWidth);

    var yAxis2 = d3.svg.axis().scale(yScale).ticks(4)
      .tickValues([loanAmount / 4, loanAmount / 2, loanAmount / 4 * 3])
      .orient('right')
      .tickPadding(3)
      .outerTickSize(0)
      .innerTickSize(0)
      .tickFormat(function(d) { return "$" + d / 1000 + "K"; });

    var line = d3.svg.line()
      .x(function(d) {
        return xScale(d.month);
      })
      .y(function(d) {
        return yScale(d.amount);
      })
      .interpolate("basis");

    var svg = d3.select('#linechart' + id)
      .append('svg')
      .attr('width', chartWidth)
      .attr('height', chartHeight);

    svg.append('g')
      .attr('transform', 'translate(0,' + (chartHeight - marginBottom) + ')')
      .attr('class', 'axis x-axis')
      .call(xAxis);

    svg.append('g')
      .attr('transform', 'translate(2, 0)')
      .attr('class', 'axis y-axis')
      .call(yAxis);

    svg.append('g')
      .attr('transform', 'translate(' + (chartWidth-marginRight) + ',0)')
      .attr('class', 'axis y-axis')
      .call(yAxis2);

    for (var i = 0; i<3; i++) {
      svg.append('g')
        .attr('class', 'line-graph')
        .append('path')
        .attr('fill', 'none')
        .attr('stroke-width', '2px')
        .attr('stroke', colors[i])
        .attr('d', line(allData[0][i]));
    }

    svg.append("path") // this is the black vertical line to follow mouse
      .attr("class","mouseLine")
      .style("stroke","black")
      .style("stroke-width", "1px")
      .style("opacity", "1");

    var sizeChart = [chartWidth - marginRight, chartHeight - marginBottom];

    var svgRect = svg.append('svg:rect') // append a rect to catch mouse movements on canvas
      .attr('width', chartWidth - marginRight) // can't catch mouse events on a g element
      .attr('height', chartHeight - marginBottom)
      .attr('fill', 'none')
      .attr('pointer-events', 'all');


    // svg.selectAll(".line-graph")
    //   .append("circle") // add a circle to follow along path
    //   .attr("class", "mouse-circle")
    //   .attr("r", 5)
    //   .style("stroke", function(d, i){return colors[i];})
    //   .style("fill","none")
    //   .style("stroke-width", "1px");

    var bisect = d3.bisector(function(d) { console.log(d); return d.month; });

    svgRect.on('mouseout', function(){
      d3.select(".mouse-circle")
        .style("stroke-width", "0px");

      svg.select(".mouseLine")
        .style("stroke-width", "0px");
    });

    svgRect.on('mouseover', function(){
      d3.select(".mouse-circle")
        .style("stroke-width", "1px");

      svg.select(".mouseLine")
        .style("stroke-width", "1px");
    });

    var x = d3.time.scale().range([0, chartWidth]);

    var y = d3.scale.linear().range([chartHeight, 0]);

    svgRect.on('mousemove', function() { // mouse moving over canvas
      svg.select(".mouseLine")
      .attr("d", function(){
        var yRange = y.range(); // range of y axis
        var xCoor = d3.mouse(this)[0]; // mouse position in x
        var xOfMonth = sizeChart[0] / numOfMonths;
        var index = Math.floor(xCoor / xOfMonth);

        $("#chart-interest" + id).html(TextFormat.formatCurrency(allData[0][0][index].amount));
        $("#chart-principal" + id).html(TextFormat.formatCurrency(allData[0][1][index].amount));
        $("#chart-remaining" + id).html(TextFormat.formatCurrency(allData[0][2][index].amount));
        $("#chart-duration" + id).html(numOfMonths - index + "mo");

        return "M"+ xCoor +"," + yRange[0] + "L" + xCoor + "," + yRange[1]; // position vertical line
      });
    });
  }
}
module.exports = ChartMixin;