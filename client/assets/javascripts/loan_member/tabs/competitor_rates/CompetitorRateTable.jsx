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
          <div className="row">
            <table className="table competitor-rates">
              <tbody><tr>
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
                  console.log(competitor_rate);
                  return (
                    <tr>
                      <td>
                        {competitor_rate.competitor_name}
                      </td>
                      {
                        _.map(competitor_rate.rates, function(rate){
                          return (
                              <div>
                                <td>
                                  {rate.lender_name}
                                  <br/>
                                  {rate.apr}
                                  <br/>
                                  {this.formatCurrency(rate.total_fee, "$")}
                                </td>
                                <td>

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
