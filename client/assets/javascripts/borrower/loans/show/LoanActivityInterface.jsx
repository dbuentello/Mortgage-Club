var _ = require('lodash');
var React = require('react/addons');

var LoanActivityInterface = React.createClass({
  getInitialState: function() {
    return {
      loan: this.props.bootstrapData.currentLoan
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

module.exports = LoanActivityInterface;
