var _ = require("lodash");
var React = require("react/addons");

var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ActivityTab = require("./tabs/ActivityTab");
var DocumentTab = require("./tabs/document/DocumentTab");
var LenderDocumentTab = require("./tabs/lender_document/LenderDocumentTab");
var ChecklistTab = require("./tabs/checklist/ChecklistTab");
var CompetitorRateTab = require("./tabs/competitor_rates/CompetitorRateTab");

var Dashboard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],
  render: function() {
    return (
      <div className="content">
        <div className="dashboard-header row mbl">
          <div className="col-xs-offset-2 col-xs-6 ptl">
            <h2>Loan member dashboard</h2>
            <h5>Loan of {this.props.bootstrapData.loan.user.to_s}</h5>
            <h5>Status: {this.props.bootstrapData.loan.status}</h5>
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
            <li role="presentation">
              <a href="#competitor_rates" aria-controls="competitor_rates" role="tab" data-toggle="tab">Competitor Rates</a>
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
                <LenderDocumentTab loan={this.props.bootstrapData.loan} lenderTemplates={this.props.bootstrapData.lender_templates} otherLenderTemplate={this.props.bootstrapData.other_lender_template}></LenderDocumentTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="checklist">
                <ChecklistTab loan={this.props.bootstrapData.loan} checklists={this.props.bootstrapData.loan.checklists} templates={this.props.bootstrapData.templates}></ChecklistTab>
              </div>
              <div role="tabpanel" className="tab-pane fade" id="competitor_rates">
                <CompetitorRateTab competitorRates={this.props.bootstrapData.competitor_rates} />
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;