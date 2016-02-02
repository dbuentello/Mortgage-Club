var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('tools/AppStarter');
var FrontendTest = require('public/FrontendTest');
var BackendTest = require('public/BackendTest');
var RateAlert = require('public/RateAlert');

window.PublicApp = React.createClass({
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
  <Route name='app' path='/' handler={PublicApp}>
    <Route name='frontend_test' handler={FrontendTest}/>
    <Route name='backend_test' handler={BackendTest}/>
    <Route name='rate-alert' handler={RateAlert}/>
    <DefaultRoute handler={BackendTest}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
