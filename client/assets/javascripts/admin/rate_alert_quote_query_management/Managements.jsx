/**
 * Manage potential users from Rate Drop Alert Page
 */
var _ = require('lodash');
var React = require('react/addons');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function(){
    return {
      rate_alert_quote_queries: this.props.bootstrapData.rate_alert_quote_queries
    }
  },

  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">Rate Alert Quote Query</span> - Management</h4>
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
                <h5 className="panel-title">Rate Alert - Quote Query</h5>
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
                      <th>First name</th>
                      <th>Last name</th>
                      <th>Quote link</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.rate_alert_quote_queries, function(rate_alert_quote) {
                        return (
                          <tr key={rate_alert_quote.id}>
                            <td>{rate_alert_quote.email}</td>
                            <td>{rate_alert_quote.first_name}</td>
                            <td>{rate_alert_quote.last_name}</td>
                            <td>
                              <a href={"/quotes/" + rate_alert_quote.code_id}>{rate_alert_quote.code_id}</a>

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
