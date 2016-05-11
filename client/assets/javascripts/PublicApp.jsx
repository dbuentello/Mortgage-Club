var $ = require('jquery');

var React = require('react/addons');
var Router = require('react-router');
var DefaultRoute = Router.DefaultRoute;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var AppStarter = require('tools/AppStarter');
var FrontendTest = require('public/FrontendTest');
var BackendTest = require('public/BackendTest');
var RateDropAlert = require('public/RateDropAlert');
var FormInitialQuotes = require('public/InitialQuotes/Form');
var InitialQuotes = require('public/InitialQuotes/Quotes');

window.PublicApp = React.createClass({
  contextTypes: {
    router: React.PropTypes.func
  },

  componentDidMount: function() {
    $("#newLoanBtn").on("click", this.createLoan);
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
    <Route name='quotes' handler={FormInitialQuotes}/>
    <Route name='quotes_list' path='/quotes/:id' handler={InitialQuotes}/>
    <Route name='refinance_alert' handler={RateDropAlert}/>
    <DefaultRoute handler={BackendTest}/>
  </Route>
);

$(function() {
  AppStarter.start(routes);
});
