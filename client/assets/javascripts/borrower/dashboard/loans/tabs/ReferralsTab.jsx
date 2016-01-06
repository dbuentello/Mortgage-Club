var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var FlashHandler = require('mixins/FlashHandler');

var ReferralsTab = React.createClass({
  mixins: [FlashHandler, TextFormatMixin],
  getInitialState: function() {
    return {
      invites: this.props.invites
    };
  },
  copyToClipboard: function() {
    try {
      // create a "hidden" input
      var aux = document.createElement("input");
      // assign it the value of the specified element
      aux.setAttribute("value", this.props.refLink);
      // append it to the body
      document.body.appendChild(aux);
      // highlight its content
      aux.select();
      // copy the highlighted text
      document.execCommand("copy");
      // remove it from the body
      document.body.removeChild(aux);

      var flash = { "alert-success": "COPIED" };
      this.showFlashes(flash);
    } catch(err) {
      if (navigator.platform.indexOf('Mac') > -1) {
        var flash = { "alert-info": "Press ⌘+C to copy." };
        this.showFlashes(flash);
      } else {
        var flash = { "alert-info": "Press Ctrl+C to copy." };
      this.showFlashes(flash);
      }
    }
    $("#refLink").select();
  },

  sendInvites: function(e) {
    var form = $(this.refs.formInvite.getDOMNode());
    $.ajax({
      url: form.attr('action'),
      data: form.serialize(),
      dataType: 'json',
      method: 'POST',
      context: this,
      success: function(response) {
        var flash = { "alert-success": response.message };
        if (response.success == false) {
          flash = { "alert-danger": response.message };
        } else {
          $('input.account-text-input').each(function(index, e) {
              $(e).val('')
          });
          this.setState({
            invites: response.invites
          });
        }
        this.showFlashes(flash);
      },
      error: function(response, status, error) {
        var flash = { "alert-danger": error };
        this.showFlashes(flash);
      }
    });
  },
  eachInvite: function(invite, i) {
    return (
      <tr key={invite.id} index={i}>
        <td>{invite.email}</td>
        <td>{invite.name}</td>
        { invite.join_at != null ?
          <td>{this.isoToUsDate(invite.join_at)}</td>
          :
          <td>-</td>
        }
        <td>0</td>
      </tr>
    );
  },
  render: function() {
    return (
      <div>
        <div className="box boxBasic backgroundBasic">
            <div className='boxHead bbs'>
              <h4 className='typeBold'>Referrals Program</h4>
            </div>
            <div className="boxBody ptm">
              <div className="col-md-12">
                Earn commission when you refer Business Purpose Borrowers (BPBs) to Mortgage Club. Below is your unique referral code. Send this link to potential BPBs or enter their emails into the form and we will invite them on your behalf. Referrals may be automated by Mortgage Club.
              </div>
              <div className="form-group ref-form col-md-12">
                <label>Your Referral Link:</label>
                <div className="input-group">
                  <div id="refLink" className="referral-link" onClick={this.copyToClipboard} defaultValue={this.props.refLink}>{this.props.refLink}</div>
                  <a className="btn copy-btn" onClick={this.copyToClipboard}>
                      COPY TO CLIPBOARD
                  </a>
                </div>
              </div>

              <form ref='formInvite' id="invite-form" className="form-group ref-form col-md-12" action="/invites" method="post">
                <label>Invite by Email:</label>

                <div className="row invite-form">
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Email</h5>
                    <input id="invite-email-1" type="email" className="form-control account-text-input" name="invite[email][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Name</h5>
                    <input id="invite-name-1" type="text" className="form-control account-text-input" name="invite[name][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Phone (Optional)</h5>
                    <input id="invite-phone-1" type="text" className="form-control account-text-input col-sm-3"  name="invite[phone][]"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Email</h5>
                    <input id="invite-email-2" type="email" className="form-control account-text-input" name="invite[email][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Name</h5>
                    <input id="invite-name-2" type="text" className="form-control account-text-input" name="invite[name][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Phone (Optional)</h5>
                    <input id="invite-phone-2" type="text" className="form-control account-text-input col-sm-3"  name="invite[phone][]"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Email</h5>
                    <input id="invite-email-3" type="email" className="form-control account-text-input" name="invite[email][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Name</h5>
                    <input id="invite-name-3" type="text" className="form-control account-text-input" name="invite[name][]"/>
                  </div>
                  <div className="col-md-4">
                    <h5 className="text-capitalize">Phone (Optional)</h5>
                    <input id="invite-phone-3" type="text" className="form-control account-text-input"  name="invite[phone][]"/>
                  </div>
                </div>

              </form>
              <div className="call-info col-md-12">
                <p className="helpful-text">
                  <img src="/icons/info.png" />
                  For specific information regarding referral bonus, please email us at hello@mortgageclub.co
                </p>
                <a className="btn send-btn text-capitalize" onClick={this.sendInvites}>SEND INVITES</a>
              </div>
            </div>
        </div>
      </div>
    );
  }
});

module.exports = ReferralsTab;