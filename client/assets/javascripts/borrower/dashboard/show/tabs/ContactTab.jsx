var _ = require('lodash');
var React = require('react/addons');

var ContactTab = React.createClass({
  render: function() {
    var ulStyle = {
      listStyleType: 'none'
    };
    return (
      <div className="box boxBasic backgroundBasic">
        <div className='boxHead bbs'>
          <h3 className='typeBold plxl'>Primary Contacts</h3>
        </div>
        <div className="boxBody ptm">
          <ul style={ulStyle}>
            {
              _.map(this.props.contactList, function(contact) {
                return (
                  <li key={contact.id}>
                    <div className='col-xs-1 ptl'>
                      <img src={contact.loan_member.user.avatar_url} className="img-circle" width="40px" height="30px"/>
                    </div>
                    <div className='col-xs-11 ptl'>
                      <p>{contact.loan_member.user.to_s} ({contact.title})</p>
                      <p><a herf="#">{contact.loan_member.user.email}</a></p>
                    </div>
                  </li>
                )
              })
            }
          </ul>
        </div>
      </div>
    )
  }
});

module.exports = ContactTab;