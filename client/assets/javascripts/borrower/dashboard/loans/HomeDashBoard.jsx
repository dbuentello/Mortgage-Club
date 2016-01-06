var _ = require('lodash');
var moment = require('moment');
var React = require('react/addons');

var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var LoansTab = require('./tabs/LoansTab');
var ReferralsTab = require('./tabs/ReferralsTab');
var SettingsTab = require('./tabs/SettingsTab');

var HomeDashBoard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    return {
      activeTab: 'loans'
    };
  },
  componentDidMount: function() {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      this.setState({
        activeTab: this.getValue(e.target.attributes, 'aria-controls').value
      });
    }.bind(this));
  },
  render: function() {
    var user = this.props.bootstrapData.user;
    var loans = this.props.bootstrapData.loans;
    var refLink = this.props.bootstrapData.refLink;
    var invites = this.props.bootstrapData.invites;
    var refCode = this.props.bootstrapData.refCode;
    var userEmail = this.props.bootstrapData.user_email;
    if (refCode != null) {
      document.cookie = "_refcode=" + refCode;
    }

    return (
     <div className="container borrower-dashboard">
          <ul className="nav nav-tabs mortgageTabs" role="tablist">
            <li role="presentation" className="active"><a href="#loans" aria-controls="loans" role="tab" data-toggle="tab" className="text-capitalize">Loans</a></li>
            <li role="presentation"><a href="#referrals" aria-controls="referrals" role="tab" data-toggle="tab" className="text-capitalize">Referrals</a></li>
            <li role="presentation"><a href="#settings" aria-controls="settings" role="tab" data-toggle="tab" class="text-capitalize">Settings</a></li>
          </ul>
          <div className='tabs'>
            <div className="tab-content">
              <div role="tabpanel" className="tab-pane fade in active" id="loans">
                <LoansTab loans={loans} />
              </div>
              <div role="tabpanel" className="tab-pane fade" id="referrals">
                <ReferralsTab refLink={refLink} invites={invites}/>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="settings">
                <SettingsTab user={user} userEmail={userEmail}/>
              </div>
            </div>
          </div>

        </div>
    )
  }
});

module.exports = HomeDashBoard;