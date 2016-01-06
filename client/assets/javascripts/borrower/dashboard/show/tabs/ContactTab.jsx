var _ = require('lodash');
var React = require('react/addons');

var ContactTab = React.createClass({
  render: function() {
    var ulStyle = {
      listStyleType: 'none'
    };
    return (
      <div className="board contact-board">
          {
            _.map(this.props.contactList, function(contact, index) {
              if(index + 1 == this.props.contactList.length){
                return (
                  <div>
                    <div className="row" key={contact.id}>
                      <div className="col-sm-2">
                        <img src={contact.loan_member.user.avatar_url} className="avatar"/>
                      </div>
                      <div className="col-sm-10">
                        <p>{contact.loan_member.user.to_s} ({contact.title})</p>
                        <p className="contact-email">
                          <a href="mailto:{contact.loan_member.user.email}">
                            {contact.loan_member.user.email}
                          </a>
                        </p>
                      </div>
                    </div>
                  </div>
                )
              }

              return (
                <div>
                  <div className="row" key={contact.id}>
                    <div className="col-sm-2">
                      <img src={contact.loan_member.user.avatar_url} className="avatar"/>
                    </div>
                    <div className="col-sm-10">
                      <p>{contact.loan_member.user.to_s} ({contact.title})</p>
                      <p className="contact-email">
                        <a href="mailto:{contact.loan_member.user.email}">
                          {contact.loan_member.user.email}
                        </a>
                      </p>
                    </div>
                  </div>
                  <hr/>
                </div>
              )
            }, this)
          }
      </div>
    )
  }
});

module.exports = ContactTab;