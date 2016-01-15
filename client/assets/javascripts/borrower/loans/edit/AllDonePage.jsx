var _ = require('lodash');
var React = require('react/addons');

var FormCreditCheck = React.createClass({
  render: function() {
    return (
      <div className="col-xs-9 account-content">
        <div className="step finish_application">
          <h1>{"You're All Done!"}</h1>
          <br/>
          <h2>{"Let's see what options you qualify for..."}</h2>
          <br/>
          <a className="btn primary yellow" rel="nofollow" data-method="put" href="#">See my rate
          </a>
        </div>
      </div>
    );
  },
});

module.exports = FormCreditCheck;
