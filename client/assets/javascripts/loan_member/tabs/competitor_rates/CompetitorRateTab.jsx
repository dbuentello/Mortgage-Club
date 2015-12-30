var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require('mixins/TextFormatMixin');


module.exports = React.createClass({
  mixins: [TextFormatMixin],

  renderTable: function(){
    var thisObject = this;
    return _.map(this.props.competitorRates, function(competitor_rate){
      return (
        <div className="competitor-name">
          <h2>
            Down payment { competitor_rate.down_payment_percentage*100 }%
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
                      <div className="col-md-12">{this.formatCurrency(rate.total_fee, "$")}</div>
                    </div>
                  </div>
                  )
              }.bind(this))
            }
          </div>
        </div>
        );
    }.bind(this));
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