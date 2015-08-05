var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

var LoanActivity = require('./admin/loan_member/LoanActivity');

window.AdminApp = React.createClass({
  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    return (
      <div>
        <RouteHandler bootstrapData={this.props}/>
      </div>
    );
  }
});

var routes = (
  <Route name='app' path='/' handler={AdminApp}>
    <Route name='loan_activity' handler={LoanActivity}/>
    <DefaultRoute handler={LoanActivity}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
