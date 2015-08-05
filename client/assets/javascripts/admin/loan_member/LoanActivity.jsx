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
      <div className='content container'>
        <h2>Loan member dashboard</h2>
      </div>
    )
  }

});

module.exports = LoanActivity;