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

    var flash = { "alert-success": "COPIED" };
    this.showFlashes(flash);
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
                Earn commission when you refer Business Purpose Borrowers(BPBs) to Mortgage Club. Below is your unique referral code. Send this link to potential BPBs or enter their emails into the form and we will invite them on your behalf. Referrals may be automated by Mortgage Club.
              </div>
              <div className="form-group ref-form col-md-6">
                <label>Your Referral Link:</label>
                <div className="input-group">
                  <input id="refLink" className="form-control" defaultValue={this.props.refLink} readOnly/>
                  <span className="input-group-btn">
                    <a className="btn btnPrimary btn-copy" onClick={this.copyToClipboard}>
                      COPY TO CLIPBOARD
                    </a>
                  </span>
                </div>
              </div>

              <div className="form-group ref-form col-md-12">
                <label>Invite by Email:</label>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)"/>
                  </div>
                </div>

                <div className="row invite-form">
                  <div className="col-md-3">
                    <input type="email" className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Email"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Name"/>
                  </div>
                  <div className="col-md-3">
                    <input className="form-control typeWeightNormal placeholder col-sm-3" placeholder="Phone (ptional)"/>
                  </div>
                </div>
                <a className="btn btnPrimary btn-invites">SEND INVITES</a>
              </div>
              <div className="call-info col-md-12">
                For specificate information regarding commissions, please call us a call at +1 234 567890
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