var _ = require('lodash');
var React = require('react/addons');

var LoanActivity = React.createClass({
  mixins: [],

  getInitialState: function() {
    return {};
  },

  getDefaultProps: function() {
    return {};
  },

  componentDidMount: function() {
    // console.dir(this.props.bootstrapData);
  },

  render: function() {
    return (
      <div className='content text-center'>
        <h1>Hello guys</h1>
      </div>
    )
  }

});

module.exports = LoanActivity;