var _ = require('lodash');
var React = require('react/addons');

var ActivitiesInterface = React.createClass({
  console.log(this.props);
  getInitialState: function() {
    return {
    };
  },

  render: function() {
    return (
      <div>
        Hello world!
      </div>
    );
  }
});

module.exports = ActivitiesInterface;
