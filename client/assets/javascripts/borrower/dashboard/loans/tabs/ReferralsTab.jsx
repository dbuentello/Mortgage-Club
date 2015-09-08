var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');

var ReferralsTab = React.createClass({
  mixins: [FlashHandler],

  copyToClipboard: function() {
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

    document.getElementById("refLink").select();

    var flash = { "alert-success": "COPIED" };
    this.showFlashes(flash);
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
          $('input.col-sm-3').each(function(index, e) {
              $(e).val('')
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
              <div className="form-group ref-form col-md-9">
                <label>Your Referral Link:</label>
                <div className="input-group">
                  <input id="refLink" className="form-control" onClick={this.copyToClipboard} defaultValue={this.props.refLink} readOnly/>
                  <span className="input-group-btn">
                    <a className="btn btnPrimary btn-copy" onClick={this.copyToClipboard}>
                      COPY TO CLIPBOARD
                    </a>
                  </span>
                </div>
              </div>

              <form ref='formInvite' id="invite-form" className="form-group ref-form col-md-12" action="/invites" method="post">
                <label>Invite by Email:</label>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email" name="invite[email][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name" name="invite[name][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)" name="invite[phone][]"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email" name="invite[email][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name" name="invite[name][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)" name="invite[phone][]"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email" name="invite[email][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name" name="invite[name][]"/>
                  </div>
                  <div className="col-md-3">
                    <input type="text" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)" name="invite[phone][]"/>
                  </div>
                </div>
                <a className="btn btnPrimary btn-invites" onClick={this.sendInvites}>SEND INVITES</a>
              </form>
              <div className="call-info col-md-12">
                For specificate information regarding commissions,
                please call us a call at: +1 123-456-7890
              </div>
            </div>
        </div>
        <div className="box boxBasic backgroundBasic">
            <div className='boxHead bbs'>
              <h4 className='typeBold'>Your Referrals</h4>
            </div>
            <div className="boxBody ptm">
              <table className="table table-striped">
                <thead>
                  <tr>
                    <th>Email</th>
                    <th>Name</th>
                    <th>Joined</th>
                    <th>#Loans Closed</th>
                  </tr>
                </thead>
                <tbody>
                  <td>thien_nga@hotmail.com</td>
                  <td>Nga T Nguyen</td>
                  <td>2015-06-01</td>
                  <td>0</td>
                </tbody>
              </table>
            </div>
        </div>
      </div>
    );
  }
});

module.exports = ReferralsTab;