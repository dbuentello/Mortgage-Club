var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require('mixins/TextFormatMixin');
module.exports = React.createClass({
  mixins: [TextFormatMixin],
  render: function(){
    {
      return (
        <div className="list-rates">
          <div className="panel panel-flat">
            <div className="panel-heading">
              <h4 className="panel-title">{this.props.title}</h4>
            </div>
            <div className="table-responsive competitor-rates">
              <table className="table table-hover competitor-rates" style={{width: "100%"}}>
                <thead>
                  <th width="9%"></th>
                  <th width="13%">30 Year Fixed</th>
                  <th width="13%">20 Year Fixed</th>
                  <th width="13%">15 Year Fixed</th>
                  <th width="13%">10 Year Fixed</th>
                  <th width="13%">7/1 ARM</th>
                  <th width="13%">5/1 ARM</th>
                  <th width="13%">3/1 ARM</th>
                </thead>
                <tbody>
                {
                  _.map(this.props.competitorRates, function(competitor_rate){
                    return (
                      <tr>
                        <td>
                          {competitor_rate.competitor_name}
                        </td>
                        {
                          _.map(competitor_rate.rates, function(rate){
                            return (
                              <div>
                                {
                                  rate.apr != 0
                                  ?
                                    <div>
                                      <td data-toggle="tooltip"
                                        title={rate.lender_name + "\n" + this.formatCurrency(rate.total_fee, "$")}
                                        data-trigger="focus"
                                        data-container="body"
                                        >
                                        <div className="panel panel-info">
                                          <div className="panel-body text-center">
                                            <p className="lead">
                                                <strong>{this.commafy(rate.apr, 3)+"% APR"}</strong>
                                            </p>
                                            <ul className="list-group list-group-flush text-center">
                                              <li className="list-group-item">{rate.lender_name}</li>
                                              <li className="list-group-item">{this.formatCurrency(rate.total_fee, "$")} Fees</li>
                                            </ul>
                                          </div>
                                        </div>
                                      </td>
                                    </div>
                                  :
                                    <div className="text-center"></div>
                                }
                              </div>
                            );
                          }.bind(this))
                        }
                      </tr>
                      );
                  }.bind(this))
                }
                </tbody>
              </table>
            </div>
          </div>
        </div>
      );
    }
  }
});
