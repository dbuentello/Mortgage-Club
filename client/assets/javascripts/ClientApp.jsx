var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

var LoanInterface = require('./client/loans/edit/LoanInterface');
var MortgageRates = require('./client/loans/MortgageRates');
var LoanActivityInterface = require('./client/loans/show/LoanActivityInterface');
var Dashboard = require('./client/dashboard/show/Dashboard');
var FlashHandler = require('mixins/FlashHandler');

window.ClientApp = React.createClass({
  mixins: [FlashHandler],

  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;

    return (
      <div>
        <nav className='topMenu sticky backgroundInverse pvm zIndexNavigation overlayFullWidth'>
          <div className='plm prl'>
            <div className='row'>
              <div className='col-xs-6 typeLowlight'>
                Homieo Logo
              </div>
              <div className='col-xs-6 text-right'>
                {user
                ? <span>
                    <a className='mrm' href='/dashboard'>Dashboard</a>
                    <span className='typeLowlight mrm'>Hello <a className='linkTypeReversed' href='/auth/register/edit' data-method='get'>{user.firstName}</a>!</span>
                    <a className='linkTypeReversed' href='/auth/logout' data-method='delete'>Log out</a>
                  </span>
                : <span>
                    <a className='linkTypeReversed mrm' href='/auth/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/auth/signup'>
                      Sign up
                    </a>
                  </span>
                }
              </div>
            </div>
          </div>
        </nav>

        <div className='page-alert'/>

        <RouteHandler bootstrapData={this.props}/>
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
    <Route name='new_loan' path='loans/new' handler={LoanInterface}/>
    <Route name='loan' path='loans/:id' handler={LoanActivityInterface}/>
    <Route name='rates' handler={MortgageRates}/>
    <Route name='dashboard' path='dashboard' handler={Dashboard}/>
    <DefaultRoute handler={LoanActivityInterface}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
