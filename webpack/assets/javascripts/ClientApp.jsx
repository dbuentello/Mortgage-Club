var React = require('react/addons');
var Main = require('./components/Main');
var AppStarter = require('./tools/AppStarter');
var $ = require('jquery');

window.ClientApp = React.createClass({
  render: function() {
    return <Main bootstrapData={this.props}/>;
  }
});

$(function() {
  AppStarter.start();
});

