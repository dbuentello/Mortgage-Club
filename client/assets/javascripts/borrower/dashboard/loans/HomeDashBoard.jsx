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
    var current_user = this.props.bootstrapData.currentUser;
    var loans = this.props.bootstrapData.loans;
    var refLink = this.props.bootstrapData.refLink;
    var invites = this.props.bootstrapData.invites;
    var refCode = this.props.bootstrapData.refCode;
    if (refCode != null) {
      document.cookie = "_refcode=" + refCode;
    }

    return (
      <div className='dashboard content'>
        <div className='dashboard-tabs phxl bts backgroundLowlight'>
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#loans" aria-controls="loans" role="tab" data-toggle="tab">Loans</a>
            </li>
            <li role="presentation">
              <a href="#referrals" aria-controls="referrals" role="tab" data-toggle="tab">Referrals</a>
            </li>
            <li role="presentation">
              <a href="#settings" aria-controls="settings" role="tab" data-toggle="tab">Settings</a>
            </li>
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
                <SettingsTab />
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = HomeDashBoard;