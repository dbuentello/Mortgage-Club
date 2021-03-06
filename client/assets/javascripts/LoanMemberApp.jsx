var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var FlashHandler = require('mixins/FlashHandler');
var AppStarter = require('tools/AppStarter');
var Loans = require('loan_member/Loans');
var Dashboard = require('loan_member/Dashboard');
var EditChecklist = require('loan_member/tabs/checklist/EditPage');
var LeadRequest = require('loan_member/LeadRequest');

window.LoanMemberApp = React.createClass({
  mixins: [FlashHandler],

  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;

    return (
      <div id="loan-member-app">
        <div className="navbar navbar-inverse">
          <div className="navbar-boxed">
            <div className="navbar-header">
              <a className="navbar-brand logo" href="/loan_members/loans">
                <img src="/white_logo.png"/>
              </a>
            </div>
            <div className="navbar-collapse collapse">
              <ul className="nav navbar-nav navbar-right">
                <li className="dropdown">
                  <a className="dropdown-toggle" href="/quotes" target="_blank">
                    Quotes
                  </a>
                </li>
                <li className="dropdown">
                  <a className="dropdown-toggle" href="/loan_members/loans">
                    My Pipeline
                  </a>
                </li>
                <li className="dropdown dropdown-user">
                  <a className="dropdown-toggle" data-toggle="dropdown">
                    <span>{user.firstName}</span>
                    <i className="caret"></i>
                  </a>
                  <ul className="dropdown-menu dropdown-menu-right">
                    <li><a href="/auth/register/profile" data-method="get"><i className="icon-user-plus"></i> My profile</a></li>
                    <li className="divider"></li>
                    <li><a href="/loan_members/lead_requests" data-method="get"><i className="icon-certificate"></i> Lead Management</a></li>
                    <li className="divider"></li>
                    <li><a href="/auth/logout" data-method="delete"><i className="icon-switch2"></i> Logout</a></li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </div>

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
  <Route name='app' path='/' handler={LoanMemberApp}>
    <Route name='loans' path='/loan_members/loans' handler={Loans}/>
    <Route name='lead_requests' path='/loan_members/lead_requests' handler={LeadRequest}/>
    <Route name='dashboard' path='/loan_members/dashboard/:id' handler={Dashboard}/>
    <Route path="/loan_members/checklists/:id/edit" handler={EditChecklist}/>
    <DefaultRoute handler={Loans}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
