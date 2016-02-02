var TextFormat = require("mixins/TextFormatMixin")
var ChartMixin = {

  drawPieChart: function(id, principal, hazardInsurance, propertyTax, mortgageInsurance, hoadue, totalMontlyPayment) {
    principal = parseFloat(principal);
    hazardInsurance = parseFloat(hazardInsurance);
    propertyTax = parseFloat(propertyTax);

    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ['Label', 'Amount'],
        ['P&I (' + TextFormat.formatCurrency(principal) + ')',       principal],
        ['Insurance (' + TextFormat.formatCurrency(hazardInsurance) + ')', hazardInsurance],
        ['Taxes (' + TextFormat.formatCurrency(propertyTax) + ')',     propertyTax]
      ]);

      if (mortgageInsurance !== undefined && mortgageInsurance !== null && mortgageInsurance !== 0){
        mortgageInsurance = parseFloat(mortgageInsurance);
        data.addRow(['H&I (' + TextFormat.formatCurrency(mortgageInsurance) + ')', mortgageInsurance])
      }

      if (hoadue !== undefined && hoadue !== null && hoadue !== 0){
        hoadue = parseFloat(hoadue);
        data.addRow(['HOA Due (' + TextFormat.formatCurrency(hoadue) + ')', hoadue])
      }

      var options = {
        pieHole: 0.5,
        chartArea: {
          left:20,
          top:0,
          width:'100%',
          height:'100%'
        },
        pieSliceText: 'value',
        tooltip: {trigger: 'selection'},
        colors: ['#3182BD', '#6BAED6', '#9ECAE1', '#C6DBEF', '#E9E4F2']
      };

      var chart = new google.visualization.PieChart(document.getElementById('piechart' + id));

      google.visualization.events.addOneTimeListener(chart, 'ready', function(entry) {
        chart.setSelection([{row: 0, column: null}]);
      });

      google.visualization.events.addListener(chart, 'onmouseover', function(entry) {
        chart.setSelection([entry]);
      });

      google.visualization.events.addListener(chart, 'onmouseout', function(entry) {
        chart.setSelection([]);
      });

      chart.draw(data, options);
    }
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

  // mortgageCalculation: function(numOfMonths, loanAmount, interestRate, monthlyPayment){
  //   var data = [];
  //   for(var i = 0; i <= numOfMonths; i++){
  //     var interest = this.totalInterestPaid1(loanAmount, interestRate, i/12, monthlyPayment);
  //     var principal = monthlyPayment * i - interest;
  //     var remaining = loanAmount - principal;

  //     data.push([i, principal, interest, remaining]);
  //   }
  //   return data;
  // },

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
    // var calculateData = this.mortgageCalculation(numOfMonths, loanAmount, interestRate, monthlyPayment);

    // google.charts.setOnLoadCallback(drawChart);

    // function drawChart() {
    //   var data = new google.visualization.DataTable();

    //   data.addColumn('number', 'Month');
    //   data.addColumn('number', 'Principal');
    //   data.addColumn('number', 'Interest');
    //   data.addColumn('number', 'Remaining');

    //   data.addRows(calculateData);

    //   var options = {
    //     curveType: 'function',
    //     legend: { position: 'bottom' }
    //   };

    //   var chart = new google.visualization.LineChart(document.getElementById('linechart' + id));

    //   chart.draw(data, options);
    // }
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