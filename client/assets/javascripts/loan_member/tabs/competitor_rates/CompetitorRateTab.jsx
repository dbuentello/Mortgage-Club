var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var CompetitorRateTable = require("./CompetitorRateTable");


module.exports = React.createClass({
  mixins: [TextFormatMixin],
  componentWillMount: function() {
    $("[data-toggle='tooltip']").tooltip();
  },

  render: function(){
    return (
      <div>
        <div>
          <CompetitorRateTable title="Down payment 20%" competitorRates={this.props.competitorRates.down_payment_20}></CompetitorRateTable>
        </div>
        <div>
          <CompetitorRateTable title="Down payment 25%" competitorRates={this.props.competitorRates.down_payment_25}></CompetitorRateTable>
        </div>
        <div>
          <CompetitorRateTable title="Down payment 10%" competitorRates={this.props.competitorRates.down_payment_10}></CompetitorRateTable>
        </div>
        <div>
          <CompetitorRateTable title="Down payment 3.5%" competitorRates={this.props.competitorRates.down_payment_3_5}></CompetitorRateTable>
        </div>
      </div>
    );
  }
});