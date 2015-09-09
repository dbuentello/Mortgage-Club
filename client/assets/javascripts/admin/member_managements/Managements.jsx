var _ = require('lodash');
var React = require('react/addons');
var Form = require('./Form');

var Managements = React.createClass({
  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return {
      members: this.props.bootstrapData.loan_members
    }
  },

  onReloadTable: function(loan_members) {
    this.setState(
      {members: loan_members}
    )
  },

  render: function() {
    var url = '/loan_member_managements/';

    return (
      <div className='content container'>
        <div className='pal'>
          <div className='row'>
            <h2 className='mbl'>Team Members</h2>
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Avatar</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Phone number</th>
                  <th>Skype</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {
                  _.map(this.state.members, function(member) {
                    return (
                      <tr key={member.id}>
                        <td>
                          <img src={member.user.avatar_url} width="40px" height="30px"/>
                        </td>
                        <td>{member.user.to_s}</td>
                        <td>{member.user.email}</td>
                        <td>{member.phone_number}</td>
                        <td>{member.skype_handle}</td>
                        <td>
                          <span>
                            <a className='linkTypeReversed btn btn-primary' href={'loan_member_managements/' + member.id + '/edit'} data-method='get'>Edit</a>
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
            <h2 className='mbl'>Add new member</h2>
            <Form Url={url} Method='POST' onReloadTable={this.onReloadTable}></Form>
          </div>
        </div>
      </div>
    )
  }

});

module.exports = Managements;