var _ = require('lodash');
var React = require('react/addons');

var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var ActivityTab = require('./tabs/ActivityTab');
var DocumentTab = require('./tabs/DocumentTab');

var Dashboard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],
  render: function() {
    return (
      <div className="content">
        <div className='dashboard-header row mbl'>
          <div className='col-xs-offset-2 col-xs-6 ptl'>
            <h2>Loan member dashboard</h2>
            <h5>Loan of {this.props.bootstrapData.loan.user.to_s}</h5>
          </div>
        </div>
        <div className='dashboard-tabs phxl backgroundLowlight'>
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#activity" aria-controls="activity" role="tab" data-toggle="tab">Activities</a>
            </li>
            <li role="presentation">
              <a href="#document" aria-controls="document" role="tab" data-toggle="tab">Documents</a>
            </li>
          </ul>

          <div className='tabs row'>
            <div className="tab-content">
              <div role="tabpanel" className="tab-pane fade in active" id="activity">
                <ActivityTab loan={this.props.bootstrapData.loan} first_activity={this.props.bootstrapData.first_activity} loan_activities={this.props.bootstrapData.loan_activities}></ActivityTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="document">
                <DocumentTab loan={this.props.bootstrapData.loan} property={this.props.bootstrapData.property} closing={this.props.bootstrapData.closing}></DocumentTab>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;