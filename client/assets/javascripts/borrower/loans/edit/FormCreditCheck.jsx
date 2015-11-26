var _ = require('lodash');
var React = require('react/addons');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var HelpTooltip = require('components/form/HelpTooltip');
var StripeCheckbox = require('components/StripeCheckbox');


var FormCreditCheck = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};
    state.credit_check_agree = this.props.loan.credit_check_agree;
    return state;
  },

  onChange: function(change) {
    console.log(change);
  },

  save: function(agree) {
    console.log(agree);
    this.setState({saving: true});
    var loan = {};
    loan.credit_check_agree = agree
    this.props.saveLoan(loan, 4, true);
  },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn box-description'>
             We’re now ready to get a real-time credit check to verify your credit score and review your credit history. You’ll be asked to pay a onetime charge of $25 for this service, which will be credited back to you upon closing.
            </div>

            <div className='box row'>
              <div className='col-xs-12'>
                <StripeCheckbox agree={this.state.credit_check_agree} save={this.save} />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  },
});

module.exports = FormCreditCheck;
