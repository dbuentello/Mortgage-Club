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
var LoanActivityInterface = require('borrower/loans/show/LoanActivityInterface');

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
    var user = this.props.currentUser;

    return (
      <div className="header clearfix shadowBottom account-nav">
        <div className="container">
          <nav className="navbar navbar-default mortgageNav">
            <div className="navbar-header">
              <a className="navbar-brand logo" href="index.html"><img src="/mortgageclubLOGO.png" alt="MortageClub"/></a>
              <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#links-home" aria-expanded="false">
                <span className="sr-only">Toggle navigation</span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
              </button>
            </div>
            <div className="collapse navbar-collapse mortgageNav" id="links-home">
              <ul className="nav nav-pills navbar-right">
                <li><a id="newLoanBtn" className="btn btn-ms btn-success theBtn text-uppercase" href="login.html" role="button"><p><span className="glyphicon glyphicon-plus-sign"></span>new loan</p></a></li>
                <li><a id="loanBtn" className="btn btn-ms theBtn text-uppercase" href="#" role="button"><img id="loanBtnImg" src="/icons/loanBtn.png" atl="loan"/>loan</a></li>
                <li><div className="dropdown">
                  <button className="btn btn-default dropdown-toggle theBtn" id="accountBtn" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                  <img id="accountBtnImg" src="/icons/userBtn.png" atl="account">Ryan</img>
                  <img className="dropdownArrow" src="/icons/dropdownArrow.png" alt="arrow"/>
                  </button>
                  <ul className="dropdown-menu" aria-labelledby="accountBtn">
                  <li><a href="#">My Profile</a></li>
                  <li><a href="#">Referrals</a></li>
                  <li><a href="#"><img id="logoutImg" src="/logoutICON.png" alt="arrow"/>Log Out</a></li>
                  </ul>
                </div></li>
              </ul>
            </div>
          </nav>
        </div>
        <RouteHandler bootstrapData={this.props}/>

        <div className='page-alert'/>

        <ModalLink
          id="newLoan"
          title="Confirmation"
          body="Are you sure to create a new loan?"
          yesCallback={this.createLoan}/>
      </div>
    );
  },

  componentDidMount: function() {
    // show flash message from Rails controller on this Client
    var flashes = this.props.flashes;
    this.showFlashes(flashes);
  }
});

var routes = (
  <Route name='app' path='/' handler={BorrowerApp}>
    <Route name='edit_loan' path='loans/:id/edit' handler={LoanInterface}/>
    <Route name='loan' path='loans/:id' handler={LoanActivityInterface}/>
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
