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

window.ClientApp = React.createClass({
  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;

    return (
      <div>
        <nav className='topMenu backgroundInverse pvm zIndexNavigation overlayFullWidth'>
          <div className='plm prl'>
            <div className='row'>
              <div className='col-xs-6 typeLowlight'>
                Homieo Logo
              </div>
              <div className='col-xs-6 text-right'>
                {user
                ? <span>
                    <span className='typeLowlight mrm'>Hello {user.firstName}!</span>
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

        <RouteHandler bootstrapData={this.props}/>
      </div>
    );
  }
});

var routes = (
  <Route name='app' path='/' handler={ClientApp}>
    <Route name='new_loan' path='loans/new' handler={LoanInterface}/>
    <Route name='loan' path='loans/:id' handler={LoanActivityInterface}/>
    <Route name='rates' handler={MortgageRates}/>
    <DefaultRoute handler={LoanActivityInterface}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
