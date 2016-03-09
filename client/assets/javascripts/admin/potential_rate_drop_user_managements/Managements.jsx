var _ = require('lodash');
var React = require('react/addons');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function(){
    return {
      potential_rate_drop_users: this.props.bootstrapData.potential_rate_drop_users
    }
  },

  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Potential Rate Drop Users</span> - Management</h4>
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
                <h5 className="panel-title">Potential Rate Drop Users</h5>
                <div className="heading-elements">

                </div>
              </div>
              <div className="panel-body">

              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Email</th>
                      <th>Refinance Purpose</th>
                      <th>ZIP Code</th>
                      <th>Credit Score</th>

                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.potential_rate_drop_users, function(potential_rate_drop_user) {
                        return (
                          <tr key={potential_rate_drop_user.id}>
                            <td>{potential_rate_drop_user.email}</td>
                            <td>{potential_rate_drop_user.refinance_purpose}</td>
                            <td>{potential_rate_drop_user.zip}</td>
                            <td>

                                {potential_rate_drop_user.credit_score}

                            </td>

                          </tr>
                        )
                      }, this)
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
    )
  }
});

module.exports = Managements;
