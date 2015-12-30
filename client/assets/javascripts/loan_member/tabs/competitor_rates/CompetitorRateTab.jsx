var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require('mixins/TextFormatMixin');


module.exports = React.createClass({
  mixins: [TextFormatMixin],

  renderTable: function(){
    var this_obj = this;
    return _.map(this.props.competitorRates, function(competitor_rate){
      return (
        <div className="competitor-name">
          <h2>
            { competitor_rate.down_rate_value*100 }%
          </h2>
          <div className="row">
            <div className="col-md-2">
              { competitor_rate.lender_name }
            </div>
            {
              _.map(competitor_rate.rates, function(rate){
                return (
                  <div className="col-md-1">
                    <div className="row">
                      <div className="col-md-12">{rate.apr}</div>
                      <div className="col-md-12">{this_obj.formatCurrency(rate.total_fee, "$")}</div>
                    </div>
                  </div>
                  )
              })
            }
          </div>
        </div>
        );
    });
  },
  render: function(){
    console.log(this.props.competitor_rates);
    return (
      <div className="table-responsive">
      {this.renderTable()}
    </div>
    );
  }
});