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
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Potential User Managements</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Email</th>
                  <th>Phone Number</th>
                  <th>Mortgage Statement</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {
                  _.map(this.state.potential_users, function(potential_user) {
                    return (
                      <tr key={potential_user.id}>
                        <td>{potential_user.email}</td>
                        <td>{potential_user.phone_number}</td>
                        <td>
                          ada
                        </td>
                        <td>
                        </td>
                      </tr>
                    )
                  }, this)
                }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Managements;