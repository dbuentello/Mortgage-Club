var React = require("react/addons");

var HomepageRates = React.createClass({
  render: function() {
    return (
      <div className="content container">
        <div className="pal">
          <div className="row">
            <h2 className="mbl">Homepage Rates</h2>
            <div className="col-md-12">
              <table className="table table-striped lenders">
                <thead>
                <tr>
                  <th>Lender Name</th>
                  <th>Program</th>
                  <th>Rate Value</th>
                  <th></th>
                </tr>
                </thead>
                <tbody>
                {
                  _.map(this.props.bootstrapData.today_rates, function(rate){
                      return (
                        <tr key={rate.id}>
                          <td nowrap>{rate.lender_name}</td>
                          <td>{rate.program}</td>
                          <td>{rate.rate_value}%</td>
                          <th>
                            <a className="linkTypeReversed btn btn-primary btn-sm col-sm-10 text-center" href={"/homepage_rates/" + rate.id + "/edit"}>Edit</a>
                          </th>
                        </tr>
                      )
                    })
                }
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = HomepageRates;