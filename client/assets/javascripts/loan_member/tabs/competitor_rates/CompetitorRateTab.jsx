var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var CompetitorRateTable = require("./CompetitorRateTable");


module.exports = React.createClass({
  mixins: [TextFormatMixin],

  render: function(){
    console.log(this.props.competitor_rates);
    return (
      <div>
        <div className="table-responsive">
            <CompetitorRateTable title="Down payment 20%" competitorRates={this.props.competitorRates.down_payment_20}></CompetitorRateTable>
        </div>
        <div className="table-responsive">
            <CompetitorRateTable title="Down payment 25%" competitorRates={this.props.competitorRates.down_payment_25}></CompetitorRateTable>
        </div>
      </div>
    );
  }
});