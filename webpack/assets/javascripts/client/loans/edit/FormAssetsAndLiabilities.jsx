var _ = require('lodash');
var React = require('react/addons');
var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var HelpTooltip = require('components/form/HelpTooltip');
var StripeButton = require('components/form/StripeButton');

var fields = {
  bankBalance: {label: 'Current Bank Balance', name: 'bank_balance', helpText: 'How much money do you have in your bank account(s) now?'},
  brokerageBalance: {label: 'Current Brokerage Balance', name: 'brokerage_balance', helpText: 'How much money do you have in your brokerage account(s) now?'},
};

var FormAssetsAndLiabilities = React.createClass({
  getInitialState: function() {
    var currentUser = this.props.bootstrapData.currentUser;
    var state = {};

    _.each(fields, function (field) {
      state[field.name] = null;
    });

    return state;
  },

  onChange: function(change) {
    this.setState(change);
  },

  onFocus: function(field) {
    this.setState({focusedField: field});
  },

  render: function() {
    return (
      <div>
        <div className='formContent'>
          <div className='pal'>
            <div className='box mvn'>
              <TextField
                label={fields.bankBalance.label}
                keyName={fields.bankBalance.name}
                value={this.state[fields.bankBalance.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.bankBalance)}
                onChange={this.onChange}/>

              <TextField
                label={fields.brokerageBalance.label}
                keyName={fields.brokerageBalance.name}
                value={this.state[fields.brokerageBalance.name]}
                editable={true}
                onFocus={this.onFocus.bind(this, fields.brokerageBalance)}
                onChange={this.onChange}/>
            </div>

            <div className='box row'>
              <div className='col-xs-6'>
                <a className='btn btnSml btnAction'>Pull credit report <i className='iconDownload'/></a>
                <HelpTooltip text='We need to get a real-time credit check to verify your credit score and review your current liabilities.'/>
              </div>
              <div className='col-xs-6 text-right'>
                <a className='btn btnSml btnPrimary'>Next</a>
              </div>
            </div>

            <div className='box row'>
              <TextField/>
              <StripeButton/>
            </div>
          </div>
        </div>

        <div className='helpSection sticky pull-right overlayRight overlayTop pal bls'>
          {this.state.focusedField && this.state.focusedField.helpText
          ? <div>
              <span className='typeEmphasize'>{this.state.focusedField.label}:</span>
              <br/>{this.state.focusedField.helpText}
            </div>
          : null}
        </div>
      </div>
    );
  }
});

module.exports = FormAssetsAndLiabilities;
