var _ = require("lodash");
var React = require("react/addons");

var ObjectHelperMixin = require("mixins/ObjectHelperMixin");
var TextFormatMixin = require("mixins/TextFormatMixin");

var ActivityTab = require("./tabs/ActivityTab");
var DocumentTab = require("./tabs/document/DocumentTab");
var LenderDocumentTab = require("./tabs/lender_document/LenderDocumentTab");
var ChecklistTab = require("./tabs/checklist/ChecklistTab");
var CompetitorRateTab = require("./tabs/competitor_rates/CompetitorRateTab");
var LoanTermsTab = require("./tabs/loan_terms/LoanTermsTab");
var Dashboard = React.createClass({
  mixins: [ObjectHelperMixin, TextFormatMixin],
  render: function() {
    var sourceData = this.props.bootstrapData;
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
                        <span className="media-heading text-bold">Loan of {sourceData.loan.user.to_s}</span>
                      </div>
                      <div className="media-right media-middle">
                        <span className="label label-info">{sourceData.loan.pretty_status}</span>
                      </div>
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
                        <a href="#lender_document" aria-controls="lender_document" role="tab" data-toggle="tab">
                          <i className="icon-file-stats"></i>
                          Lender Documents
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#checklist" aria-controls="checklist" role="tab" data-toggle="tab">
                          <i className="icon-clipboard2"></i>
                          Checklists
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#competitor_rates" aria-controls="competitor_rates" role="tab" data-toggle="tab">
                          <i className="icon-list3"></i>
                          Competitor Rates
                        </a>
                      </li>
                      <li role="presentation">
                        <a href="#loan_terms" aria-controls="loan_terms" role="tab" data-toggle="tab">
                          <i className="icon-list3"></i>
                          Loan Terms
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
                  <ActivityTab loan={sourceData.loan} first_activity={sourceData.first_activity} loan_activities={sourceData.loan_activities} activity_types={sourceData.activity_types}></ActivityTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="document">
                  <DocumentTab loan={sourceData.loan} borrower={sourceData.borrower} property={sourceData.property} closing={sourceData.closing}></DocumentTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="lender_document">
                  <LenderDocumentTab loan={sourceData.loan} lenderTemplates={sourceData.lender_templates} otherLenderTemplate={sourceData.other_lender_template}></LenderDocumentTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="checklist">
                  <ChecklistTab loan={sourceData.loan} checklists={sourceData.loan.checklists} templates={sourceData.templates}></ChecklistTab>
                </div>
                <div role="tabpanel" className="tab-pane fade" id="competitor_rates">
                  <CompetitorRateTab competitorRates={sourceData.competitor_rates} />
                </div>
                <div role="tabpanel" className="tab-pane fade" id="loan_terms">
                  <LoanTermsTab loan={sourceData.loan} />
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