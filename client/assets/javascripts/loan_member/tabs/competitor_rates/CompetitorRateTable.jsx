var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require('mixins/TextFormatMixin');
module.exports = React.createClass({
  mixins: [TextFormatMixin],
  render: function(){
    {
      return (
        <div>
          <div className="panel-heading">
            <h4>{this.props.title}</h4>
          </div>
          <div className="table-responsive competitor-rates">
            <table className="table competitor-rates">
              <tbody>
                <tr>
                <th></th>
                <th>30 Year Fixed</th>
                <th>20 Year Fixed</th>
                <th>15 Year Fixed</th>
                <th>10 Year Fixed</th>
                <th>7/1 ARM</th>
                <th>5/1 ARM</th>
                <th>3/1 ARM</th>
              </tr>
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
                                <td data-toggle="tooltip"
                                  title={rate.lender_name + "\n" + this.formatCurrency(rate.total_fee, "$")}
                                  data-trigger="focus"
                                  data-container="body"
                                  >
                                  <div className="panel panel-info">
                                    {
                                      rate.apr != 0
                                      ?
                                        <div className="panel-body text-center">
                                          <p className="lead">
                                              <strong>{this.commafy(rate.apr, 3)+"% APR"}</strong>
                                          </p>
                                          <ul className="list-group list-group-flush text-center">
                                            <li className="list-group-item">{rate.lender_name}</li>
                                            <li className="list-group-item">{this.formatCurrency(rate.total_fee, "$")} Fees</li>
                                          </ul>
                                        </div>
                                      :
                                        <div className="panel-body text-center"></div>
                                    }
                                  </div>
                                </td>
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
      );
    }
  }
});
