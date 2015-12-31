var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require('mixins/TextFormatMixin');
module.exports = React.createClass({
  mixins: [TextFormatMixin],
  render: function(){
    {
      return (
        <div>
          <h4>{this.props.title}</h4>
          {
            _.map(this.props.competitorRates, function(competitor_rate){
              return (
                <div className="competitor-name">

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
            }.bind(this))
          }
        </div>
      );
    }
  }
});
