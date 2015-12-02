var _ = require("lodash");
var React = require("react/addons");

var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ActivityTab = require("./tabs/ActivityTab");
var DocumentTab = require("./tabs/document/DocumentTab");
var LenderDocumentTab = require("./tabs/lender_document/LenderDocumentTab");
var ChecklistTab = require("./tabs/checklist/ChecklistTab");

// fake templates to work temporarily
var templates = [
{id: "1", name: "Wholesale Submission Form", description: "This is a Wholesale Submission Form"},
{id: "2", name: "Complete 1003 dated", description: "This is a Complete 1003 dated Form"},
{id: "3", name: "Loan Estimate within 3 days of the 10003", description: "This is a Loan Estimate 1003 Form"},
{id: "4", name: "Other Document", description: "This is an other document", is_other: true},
]

var Dashboard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],
  render: function() {
    return (
      <div className="content">
        <div className="dashboard-header row mbl">
          <div className="col-xs-offset-2 col-xs-6 ptl">
            <h2>Loan member dashboard</h2>
            <h5>Loan of {this.props.bootstrapData.loan.user.to_s}</h5>
          </div>
        </div>
        <div className="dashboard-tabs phxl backgroundLowlight">
          <ul className="nav nav-tabs" role="tablist">
            <li role="presentation" className="active">
              <a href="#activity" aria-controls="activity" role="tab" data-toggle="tab">Activities</a>
            </li>
            <li role="presentation">
              <a href="#document" aria-controls="document" role="tab" data-toggle="tab">Documents</a>
            </li>
            <li role="presentation">
              <a href="#lender_document" aria-controls="lender_document" role="tab" data-toggle="tab">Lender Documents</a>
            </li>
            <li role="presentation">
              <a href="#checklist" aria-controls="checklist" role="tab" data-toggle="tab">Checklists</a>
            </li>
          </ul>

          <div className="tabs row">
            <div className="tab-content">
              <div role="tabpanel" className="tab-pane fade in active" id="activity">
                <ActivityTab loan={this.props.bootstrapData.loan} first_activity={this.props.bootstrapData.first_activity} loan_activities={this.props.bootstrapData.loan_activities}></ActivityTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="document">
                <DocumentTab loan={this.props.bootstrapData.loan} borrower={this.props.bootstrapData.borrower} property={this.props.bootstrapData.property} closing={this.props.bootstrapData.closing}></DocumentTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="lender_document">
                <LenderDocumentTab loan={this.props.bootstrapData.loan} templates={templates}></LenderDocumentTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="checklist">
                <ChecklistTab loan={this.props.bootstrapData.loan} checklists={this.props.bootstrapData.loan.checklists} templates={this.props.bootstrapData.templates}></ChecklistTab>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;