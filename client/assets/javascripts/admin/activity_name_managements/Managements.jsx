/**
 * Manage loan activity type
 */
var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      activity_names: this.props.bootstrapData.activity_names
    }
  },

  onReloadTable: function(activity_names) {
    this.setState({activity_names: activity_names});
  },

  render: function() {
    var url = '/loan_activity_name_managements/';

    return (
      <div>
        {/* header */}
        <div className="page-header">
          <div className="page-header-content">
            <div className="page-title">
              <h4>
                <i className="icon-arrow-left52 position-left"> </i>
                <span className="text-semibold"> Loan Activity Name - Managements </span>
              </h4>
            </div>
          </div>
        </div>
        {/* end header */}

        <div className="page-container">
          <div className="page-content">
            <div className="content-wrapper">
              <div className="panel panel-flat">
                <div className="panel-heading">
                  <h5 className="panel-title">Loan Activity Name</h5>
                  <div className="heading-elements">
                  </div>
                </div>
                <div class="panel-body">
                      </div>
                        <div className="table-responsive">
                          <table className="table table-striped">
                            <thead>
                              <tr>
                                <th>Activity Type</th>
                                <th>Activity Name</th>
                                <th></th>
                              </tr>
                            </thead>
                            <tbody>
                              {
                                _.map(this.state.activity_names, function(activity_name) {
                                  console.log(activity_name);
                                  return (
                                    <tr key={activity_name.id}>
                                      <td>{activity_name.activity_type.label}</td>
                                      <td>{activity_name.name}</td>
                                      <td>
                                        <span>
                                          <a className='linkTypeReversed btn btn-primary' href={'loan_activity_name_managements/' + activity_name.id + '/edit'} data-method='get'>Edit</a>
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
                <div className="row">
                  <div className="col-md-12">
                    <div className="panel panel-flat">
                      <div className="panel-heading">
                        <h5 className="panel-title">Add new Activity Name</h5>
                        <div className="heading-elements">
                        </div>
                      </div>
                      <div className="panel-body">
                        <Form Url={url} Method='POST' onReloadTable={this.onReloadTable} ActivityTypes={this.props.bootstrapData.activity_types}></Form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
      </div>
    )
  }
});

module.exports = Managements;
