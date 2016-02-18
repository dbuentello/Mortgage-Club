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
      <div>
        <div className="page-header">
          <div className="page-header-content">
            <div className="page-title">
              <h4>Loan member dashboard</h4>
            </div>
          </div>
        </div>
        <div className="page-container">
          <div className="page-content">
            <div className="sidebar sidebar-main sidebar-default">
              <div className="sidebar-content">
                <div className="sidebar-category sidebar-category-visible">
                  <div className="category-content sidebar-user">
                    <div className="media">
                      <div className="media-body">
                        <span className="media-heading text-bold">Loan of {this.props.bootstrapData.loan.user.to_s}</span>
                      </div>
                      <div className="media-right media-middle">
                        <span className="label label-primary">{this.props.bootstrapData.loan.pretty_status}</span>
                      </div>
                    </div>
                  </div>
                  <div className="category-content no-padding">
                    <ul className="navigation navigation-main navigation-accordion" role="tablist">
                      <li role="presentation" className="active">
                        <a href="#activity" aria-controls="activity" role="tab" data-toggle="tab">
                          Activities
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#document" aria-controls="document" role="tab" data-toggle="tab">
                          Documents
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#lender_document" aria-controls="lender_document" role="tab" data-toggle="tab">
                          Lender Documents
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#checklist" aria-controls="checklist" role="tab" data-toggle="tab">
                          Checklists
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#competitor_rates" aria-controls="competitor_rates" role="tab" data-toggle="tab">
                          Competitor Rates
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
            <div className="content-wrapper">
              <div className="panel panel-flat">
                <div className="panel-body">
                  <div className="tab-content">
                    <div role="tabpanel" className="tab-pane fade in active" id="activity">
                      <ActivityTab loan={this.props.bootstrapData.loan} first_activity={this.props.bootstrapData.first_activity} loan_activities={this.props.bootstrapData.loan_activities} activity_types={this.props.bootstrapData.activity_types}></ActivityTab>
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
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Dashboard;