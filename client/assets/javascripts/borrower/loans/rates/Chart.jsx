var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var Chart = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function(){
    console.log(this.props);
    return ({
      principle: this.props.rate.monthly_payment,
      mortgageInsurance: this.props.state.estimatedMortgageInsurance,
      propertyTax: this.props.state.estimatedPropertyTax,
      hazardInsurance: this.props.state.estimatedHazardInsurance,
      total: this.props.total
    });
  },
  render: function() {
    return (
      <div className="row chart-part">
        <div class="col-md-4"></div>
        <div class="col-md-8"></div>
        <p>{this.state.principle}</p>
        <p>{this.state.mortgageInsurance}</p>
        <p>{this.state.propertyTax}</p>
        <p>{this.state.hazardInsurance}</p>
        <p>{this.state.total}</p>
      </div>
    );
  }
});

module.exports = Chart;