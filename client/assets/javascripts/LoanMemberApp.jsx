var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var FlashHandler = require('mixins/FlashHandler');
var AppStarter = require('tools/AppStarter');
var Loans = require('loan_member/Loans')
var Dashboard = require('loan_member/Dashboard');

window.LoanMemberApp = React.createClass({
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
                <a className='mrl' href='/loan_activities'> MortgageClub </a>
              </div>
              <div className='col-xs-6 text-right'>
                {user
                ? <span>
                    <a className='mrm' href='/loan_activities'>Loan List</a>
                    <span className='typeLowlight mrm'>Hello <a className='linkTypeReversed' href='/auth/register/edit' data-method='get'>{user.firstName}</a>!</span>
                    <a className='linkTypeReversed' href='/auth/logout' data-method='delete'>Log out</a>
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

        <div className='page-alert'/>

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
  <Route name='app' path='/' handler={LoanMemberApp}>
    <Route name='loans' path='/loan_activities' handler={Loans}/>
    <Route name='loan_activities' path='/loan_activities/:id' handler={Dashboard}/>
    <DefaultRoute handler={Loans}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
