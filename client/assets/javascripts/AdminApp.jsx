var $ = require("jquery");

var React = require("react/addons");
var Router = require("react-router");
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var FlashHandler = require("mixins/FlashHandler");
var AppStarter = require("tools/AppStarter");
var Loans = require("admin/Loans");
var MortgageData = require("admin/mortgage_data_managements/MortgageData");
var MortgageDataRecord = require("admin/mortgage_data_managements/MortgageDataRecord");

var LoanMemberManagements = require("admin/member_managements/Managements");
var EditMemberPage = require("admin/member_managements/EditPage");

var LoanMembersTitleManagements = require("admin/loan_members_titles/Managements");
var EditLoanMembersTitle = require("admin/loan_members_titles/EditPage");

var SettingManagements = require("admin/setting_managements/Managements");
var EditSettingPage = require("admin/setting_managements/EditPage");

var LoanFaqManagements = require("admin/faq_managements/Managements");
var EditFaqPage = require("admin/faq_managements/EditPage");

var LoanActivityTypeManagements = require("admin/activity_type_managements/Managements");
var EditActivityTypePage = require("admin/activity_type_managements/EditPage");

var Lenders = require("admin/lenders/Lenders");
var LenderForm = require("admin/lenders/LenderForm");

var LenderTemplates = require("admin/lenders/LenderTemplates");
var EditTemplate = require("admin/lenders/EditTemplate");

var LenderDocusignForms = require("admin/lenders/LenderDocusignForms");

var PotentialUserManagements = require("admin/potential_user_managements/Managements");
var EditPotentialUserPage = require("admin/potential_user_managements/EditPage");

var PotentialRateDropUserManagements = require("admin/potential_rate_drop_user_managements/Managements");
var EditPotentialRateDropUserPage = require("admin/potential_rate_drop_user_managements/EditPage");

var RateAlertQuoteQueryManagements = require("admin/rate_alert_quote_query_management/Managements");

var BorrowerManagements = require("admin/borrower_managements/Borrowers");

var HomepageRateManagement = require("admin/homepage_rate_managements/Managements");
var HomepageRateForm = require("admin/homepage_rate_managements/Form");

var LoanURLTokens = require("admin/loan_url_tokens_managements/LoanTokens");

window.AdminApp = React.createClass({
  mixins: [FlashHandler],

  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;

    return (
      <div>

        <div className="page-alert"/>

        <RouteHandler bootstrapData={this.props}/>
      </div>
    );
  },

  componentDidMount: function() {
    var flashes = this.props.flashes;
    this.showFlashes(flashes);
  }
});

var routes = (
  <Route name="app" path="/" handler={AdminApp}>
    <Route name="loans" path="/loan_assignments" handler={Loans}/>
    <Route name="loan_member_managements" path="/loan_member_managements" handler={LoanMemberManagements}/>
    <Route path="/loan_member_managements/:id/edit" handler={EditMemberPage}/>
    <Route name="loan_faq_managements" path="/loan_faq_managements" handler={LoanFaqManagements}/>
    <Route path="/loan_members_titles" handler={LoanMembersTitleManagements}/>
    <Route path="/loan_members_titles/:id/edit" handler={EditLoanMembersTitle}/>
    <Route path="/settings" handler={SettingManagements}/>
    <Route path="/settings/:id/edit" handler={EditSettingPage}/>
    <Route path="/loan_faq_managements/:id/edit" handler={EditFaqPage}/>
    <Route name="loan_activity_type_managements" path="/loan_activity_type_managements" handler={LoanActivityTypeManagements}/>
    <Route path="/loan_activity_type_managements/:id/edit" handler={EditActivityTypePage}/>
    <Route path="/lenders" handler={Lenders}/>
    <Route path="/homepage_rates" handler={HomepageRateManagement}/>
    <Route path="/homepage_rates/:id/edit" handler={HomepageRateForm}/>
    <Route path="/lenders/new" handler={LenderForm}/>
    <Route path="/lenders/:id/edit" handler={LenderForm}/>
    <Route path="/lenders/:id/lender_templates" handler={LenderTemplates}/>
    <Route path="/lenders/:id/lender_templates/:id/edit" handler={EditTemplate}/>
    <Route path="/lenders/:id/lender_docusign_forms" handler={LenderDocusignForms}/>

    <Route name="/potential_user_managements" path="/potential_user_managements" handler={PotentialUserManagements}/>
    <Route path="/potential_user_managements/:id/edit" handler={EditPotentialUserPage}/>
    <Route name="/potential_rate_drop_user_managements" path="/potential_rate_drop_user_managements" handler={PotentialRateDropUserManagements}/>
    <Route path="/potential_rate_drop_user_managements/:id/edit" handler={EditPotentialRateDropUserPage}/>
      <Route name="/rate_alert_quote_query_managements" path="/rate_alert_quote_query_managements" handler={RateAlertQuoteQueryManagements}/>

    <Route path="/borrower_managements" handler={BorrowerManagements}/>
    <Route path="/mortgage_data" handler={MortgageData}/>
    <Route path="/mortgage_data/:id" handler={MortgageDataRecord}/>
    <Route path="/loan_url_tokens" handler={LoanURLTokens}/>

    <DefaultRoute handler={Loans}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
