var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

var LoanInterface = require('./components/LoanInterface');
var MortgageRates = require('./components/MortgageRates');

window.ClientApp = React.createClass({
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
                    <span className='typeLowlight mrm'>Hello {user.firstName}!</span>
                    <a className='linkTypeReversed' href='/logout'>Log out</a>
                  </span>
                : <span>
                    <a className='linkTypeReversed mrm' href='/login'>
                      Log in
                    </a>
                    <a className='linkTypeReversed mrm' href='/signup'>
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
    <Route name='loans/new' handler={LoanInterface}/>
    <Route name='rates' handler={MortgageRates}/>
    <DefaultRoute handler={LoanInterface}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
