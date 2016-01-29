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
      </div>
    )
  }
});

module.exports = Managements;