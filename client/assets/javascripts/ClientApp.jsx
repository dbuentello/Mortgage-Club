var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('tools/AppStarter');
var FlashHandler = require('mixins/FlashHandler');
var LoanInterface = require('client/loans/edit/LoanInterface');
var MortgageRates = require('client/loans/MortgageRates');
var LoanActivityInterface = require('client/loans/show/LoanActivityInterface');
var Dashboard = require('client/dashboard/show/Dashboard');
var LoanList = require('client/dashboard/loans/LoanList');

var ModalLink = require('components/ModalLink');

window.ClientApp = React.createClass({
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
      <div>
        <nav className='topMenu sticky backgroundInverse pvm zIndexNavigation overlayFullWidth'>
          <div className='plm prl'>
            <div className='row'>
              <div className='col-xs-6 typeLowlight'>
                <a className='mrl' href='/dashboard/loans'> MortgageClub </a>
              </div>
              <div className='col-xs-6 text-right'>
                {user
                ? <span>
                    <a className="mrl" data-toggle="modal" data-target="#newLoan" style={{'cursor': 'pointer'}}><i className="iconPlus mrxs"/>New Loan</a>
                    <a className='mrl' href='/dashboard/loans'><i className='iconFolder mrxs'/>Loans</a>
                    <span className='typeLowlight mrl'>Hello <a className='linkTypeReversed' href='/auth/register/edit' data-method='get'>{user.firstName}</a>!</span>
                    <a className='linkTypeReversed' href='/auth/logout' data-method='delete'><i className='iconUser mrxs'/>Log out</a>
                  </span>
                : <span>
                    <a className='linkTypeReversed mrm' href='/auth/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/auth/register/signup'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>

        <RouteHandler bootstrapData={this.props}/>

        <div className='page-alert'/>

        <ModalLink
          id="newLoan"
          title="Confirmation"
          body="Are you sure to create a new loan?"
          yesCallback={this.createLoan}
        />
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
  <Route name='app' path='/' handler={ClientApp}>
    <Route name='edit_loan' path='loans/:id/edit' handler={LoanInterface}/>
    <Route name='loan' path='loans/:id' handler={LoanActivityInterface}/>
    <Route name='rates' handler={MortgageRates}/>
    <Route name='loan_list' path='dashboard/loans' handler={LoanList}/>
    <Route name='loan_dashboard' path='dashboard/:id/edit' handler={Dashboard}/>
    <DefaultRoute handler={LoanActivityInterface}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
