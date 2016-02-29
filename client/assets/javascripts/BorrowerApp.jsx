var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('tools/AppStarter');
var FlashHandler = require('mixins/FlashHandler');
var ModalLink = require('components/ModalLink');

var LoanInterface = require('borrower/loans/edit/LoanInterface');
var MortgageRates = require('borrower/loans/rates/MortgageRates');
var Underwriting = require('borrower/loans/underwriting/Underwriting');
var ESigning = require('borrower/loans/DocusignIframe');

var Dashboard = require('borrower/dashboard/show/Dashboard');
var HomeDashBoard = require('borrower/dashboard/loans/HomeDashBoard');

window.BorrowerApp = React.createClass({
  mixins: [FlashHandler],

  contextTypes: {
    router: React.PropTypes.func
  },

  createLoan: function() {
    $.ajax({
      url: '/loans',
      method: 'POST',
      dataType: 'json',
      success: function(response) {
        location.href = '/loans/' + response.loan_id + '/edit';
      },
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div>
        <RouteHandler bootstrapData={this.props}/>
        <div className='page-alert'/>
      </div>
    );
  },

  componentDidMount: function() {
    // show flash message from Rails controller on this Client
    var flashes = this.props.flashes;
    this.showFlashes(flashes);
    $("#newLoanBtn").on("click", this.createLoan);
  }
});

var routes = (
  <Route name='app' path='/' handler={BorrowerApp}>
    <Route name='edit_loan' path='loans/:id/edit' handler={LoanInterface}/>
    <Route name='show_loan' path='loans/:id' handler={LoanInterface}/>
    <Route name='underwriting' handler={Underwriting}/>
    <Route name='rates' handler={MortgageRates}/>
    <Route name='loan_list' path='my/loans' handler={HomeDashBoard}/>
    <Route name='loan_dashboard' path='my/dashboard/:id' handler={Dashboard}/>
    <Route name='esigning' path='esigning/:id' handler={ESigning}/>
    <DefaultRoute handler={HomeDashBoard}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
