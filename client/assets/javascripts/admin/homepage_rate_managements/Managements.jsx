var React = require("react/addons");

var HomepageRates = React.createClass({
  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Homepage Rates</span> - Management</h4>
          </div>
        </div>
      </div>
      {/* /page header */ }

      {/* Page container */ }
      <div className="page-container">

        {/* Page content */ }
        <div className="page-content">

          {/* Main content */ }
          <div className="content-wrapper">

            {/* Table */ }
            <div className="panel panel-flat">
              <div className="panel-heading">
                <h5 className="panel-title">Homepage Rates</h5>
                <div className="heading-elements">
                  
                </div>
              </div>
              <div className="panel-body">

              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Lender Name</th>
                      <th>Program</th>
                      <th>Rate Value</th>
                      <th>Actions</th>
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
            {/* /table */ }

          </div>
          {/* /main content */ }

        </div>
        {/* /page content */ }

      </div>
      {/* /page container */ }
    </div>
    );
  }
});

module.exports = HomepageRates;
