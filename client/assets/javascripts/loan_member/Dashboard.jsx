var _ = require("lodash");
var React = require("react/addons");

var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ActivityTab = require("./tabs/ActivityTab");
var DocumentTab = require("./tabs/document/DocumentTab");
var ChecklistTab = require("./tabs/checklist/ChecklistTab");
var CompetitorRateTab = require("./tabs/competitor_rates/CompetitorRateTab");
var LoanTermsTab = require("./tabs/loan_terms/LoanTermsTab");
var LoanUrlTokenTab = require("./tabs/loan_url_tokens/LoanUrlTokenTab");
var EmailDashboardTab = require("./tabs/email_dashboard/EmailDashboardTab");

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
                      <p className="text-bold">{this.props.bootstrapData.property.address.full_text}</p>
                      <span className="label label-info">{this.props.bootstrapData.loan.pretty_status}</span>
                    </div>
                  </div>
                  <div className="category-content no-padding">
                    <ul className="navigation navigation-main navigation-accordion" role="tablist">
                      <li role="presentation" className="active">
                        <a href="#activity" aria-controls="activity" role="tab" data-toggle="tab">
                          <i className="icon-home4"></i>
                          Activities
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#document" aria-controls="document" role="tab" data-toggle="tab">
                          <i className="icon-file-text2"></i>
                          Documents
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#checklist" aria-controls="checklist" role="tab" data-toggle="tab">
                          <i className="icon-clipboard2"></i>
                          Checklist
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#quote_terms" aria-controls="quote_terms" role="tab" data-toggle="tab">
                          <i className="icon-list"></i>
                          Loan Terms
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#loan_url_token" aria-controls="loan_url_token" role="tab" data-toggle="tab">
                          <i className="icon-sphere"></i>
                          Loan URL Token
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#email_dashboard" aria-controls="email_dashboard" role="tab" data-toggle="tab">
                          <i className="icon-mail5"></i>
                          Email
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
            <div className="content-wrapper">
              <div className="tab-content">
                <div role="tabpanel" className="tab-pane fade in active" id="activity">
                  <ActivityTab
                    loan={this.props.bootstrapData.loan}
                    first_activity={this.props.bootstrapData.first_activity}
                    loan_activities={this.props.bootstrapData.loan_activities}
                    activity_types={this.props.bootstrapData.activity_types} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="document">
                  <DocumentTab
                    loan={this.props.bootstrapData.loan}
                    borrower={this.props.bootstrapData.borrower}
                    property={this.props.bootstrapData.property}
                    closing={this.props.bootstrapData.closing} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="checklist">
                  <ChecklistTab
                    loan={this.props.bootstrapData.loan}
                    checklists={this.props.bootstrapData.checklists}
                    templates={this.props.bootstrapData.templates} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="quote_terms">
                  <LoanTermsTab
                    loan={this.props.bootstrapData.loan}
                    property={this.props.bootstrapData.property} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="loan_url_token">
                  <LoanUrlTokenTab
                    loan={this.props.bootstrapData.loan}
                    url={this.props.bootstrapData.url} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="email_dashboard">
                  <EmailDashboardTab
                    loan={this.props.bootstrapData.loan}
                    property={this.props.bootstrapData.property}
                    loanMember={this.props.bootstrapData.loan_member}
                    borrower={this.props.bootstrapData.borrower}
                    emailTemplates={this.props.bootstrapData.email_templates}
                    listEmails={this.props.bootstrapData.list_emails}
                    loanEmails={this.props.bootstrapData.loan_emails} />
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