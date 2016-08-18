/**
 * done page is shown when user finish all forms.
 */

var _ = require('lodash');
var React = require('react/addons');

var FormCreditCheck = React.createClass({
  componentDidMount: function(){
    $("body").scrollTop(0);
  },

  render: function() {
    return (
      <div className="col-xs-12 col-sm-12 col-md-3 account-content">
        {
          this.props.loan.lender_name
          ?
        <div className="step finish_application">
          <span className="glyphicon glyphicon-ok"></span>
          <h1>{"You're All Done!"}</h1>
          <br/>

          <h2>{"Next, we'll run a preliminary check to make sure you qualify for the loan program that you selected..."}</h2>
          <br/>
            <a className="btn primary yellow" rel="nofollow" data-method="get" href={"/underwriting?loan_id=" + this.props.loan.id}>
              Continue
            </a>
          </div>

            :
            <div className="step finish_application">
              <span className="glyphicon glyphicon-ok"></span>
              <h1>{"You're All Done!"}</h1>
              <br/>
            <h2>{"Let's see what loan programs you qualify for..."}</h2>
            <br/>
            <a className="btn primary yellow" rel="nofollow" data-method="get" href={"/underwriting?loan_id=" + this.props.loan.id}>
              See my rates
            </a>

        </div>
        }
      </div>
    );
  },
});

module.exports = FormCreditCheck;
