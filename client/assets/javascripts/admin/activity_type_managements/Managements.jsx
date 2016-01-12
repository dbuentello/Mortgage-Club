var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      activity_types: this.props.bootstrapData.activity_types
    }
  },

  onReloadTable: function(activity_types) {
    this.setState({activity_types: activity_types});
  },

  render: function() {
    var url = '/loan_activity_type_managements/';

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Activity Types Managements</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Label</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {
                  _.map(this.state.activity_types, function(activity_type) {
                    return (
                      <tr key={activity_type.id}>
                        <td>{activity_type.label}</td>
                        <td>
                          <span>
                            <a className='linkTypeReversed btn btn-primary' href={'loan_activity_type_managements/' + activity_type.id + '/edit'} data-method='get'>Edit</a>
                          </span>
                        </td>
                      </tr>
                    )
                  }, this)
                }
              </tbody>
            </table>
          </div>
          <div className='row'>
            <h2 className='mbl'>Add new Activity Type</h2>
            <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Managements;