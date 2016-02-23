var _ = require('lodash');
var React = require('react/addons');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function(){
    return {
      potential_users: this.props.bootstrapData.potential_users
    }
  },

  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Potential Users</span> - Management</h4>
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
                <h5 className="panel-title">Potential Users</h5>
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
                      <th>Phone Number</th>
                      <th>Send As</th>
                      <th>Mortgage Statement</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.potential_users, function(potential_user) {
                        return (
                          <tr key={potential_user.id}>
                            <td>{potential_user.email}</td>
                            <td>{potential_user.phone_number}</td>
                            <td>{potential_user.alert_method}</td>
                            <td>
                              <a href={potential_user.url}>
                                {potential_user.mortgage_statement_file_name}
                              </a>
                            </td>
                            <td>
                              <span>
                                <a className='linkTypeReversed btn btn-primary' href={'potential_user_managements/' + potential_user.id + '/edit'} data-method='get'>Edit</a>
                              </span>
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
