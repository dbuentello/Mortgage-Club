var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

var TakeHomeTest = require('./public/TakeHomeTest');

window.PublicApp = React.createClass({
  contextTypes: {
    router: React.PropTypes.func
  },

  render: function() {
    var user = this.props.currentUser;
    return (
      <div>
        <RouteHandler bootstrapData={this.props}/>
      </div>
    );
  }
});

var routes = (
  <Route name='app' path='/' handler={PublicApp}>
    <Route name='take_home_test' handler={TakeHomeTest}/>
    <DefaultRoute handler={TakeHomeTest}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
