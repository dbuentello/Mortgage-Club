var _ = require('lodash');
var React = require('react/addons');

var ContactTab = React.createClass({
  render: function() {
    var ulStyle = {
      listStyleType: 'none'
    };
    return (
      <div className="box boxBasic backgroundBasic">
        <div className="boxBody ptm">
          <table className="table table-striped">
            <thead>
              <tr>
                <th>Avatar</th>
                <th>Name</th>
                <th>Email</th>
              </tr>
            </thead>
            <tbody>
            {
              _.map(this.props.contactList, function(contact) {
                return (
                  <tr key={contact.id}>
                    <td>
                      <img src={contact.loan_member.user.avatar_url} className="img-circle" width="40px" height="30px"/>
                    </td>
                    <td>{contact.loan_member.user.to_s} ({contact.title})</td>
                    <td>{contact.loan_member.user.email}</td>
                  </tr>
                )
              }, this)
            }
            </tbody>
          </table>
        </div>
      </div>
    )
  }
});

module.exports = ContactTab;