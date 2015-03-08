var React = require('react/addons');

// Next line is necessary for exposing React to browser for
// the React Developer Tools: http://facebook.github.io/react/blog/2014/01/02/react-chrome-developer-tools.html
// require("expose?React!react");

var HelloWorld = React.createClass({
  render: function() {
    return (
      <div>
        Hello World!
      </div>
    );
  }
});

export { HelloWorld };
