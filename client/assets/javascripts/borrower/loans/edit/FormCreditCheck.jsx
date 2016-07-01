var _ = require('lodash');
var React = require('react/addons');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var HelpTooltip = require('components/form/HelpTooltip');

var FormCreditCheck = React.createClass({
  getInitialState: function() {
    var state = {};
    state.credit_check_agree = this.props.loan.credit_check_agree;
    return state;
  },

  onChange: function(change) {
  },

  save: function(agree) {
    this.setState({saving: true});
    var loan = {};
    loan.credit_check_agree = agree
    this.props.saveLoan(loan, 4, true);
  },

  componentDidMount: function(){
    $("body").scrollTop(0);
  },

  render: function() {
    return (
      <div className='col-sm-9 col-xs-12 account-content'>
        <form className='form-horizontal'>
          <div className='form-group'>
            <p className="box-description col-sm-12">
              We’re now ready to get a real-time credit check to verify your credit score and review your credit history. You’ll be asked to pay a onetime charge of $25 for this service, which will be credited back to you upon closing.
            </p>
          </div>
        </form>
      </div>
    );
  },
});

module.exports = FormCreditCheck;
