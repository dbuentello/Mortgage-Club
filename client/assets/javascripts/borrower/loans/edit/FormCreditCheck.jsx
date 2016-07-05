var _ = require('lodash');
var React = require('react/addons');

var AddressField = require('components/form/AddressField');
var DateField = require('components/form/DateField');
var SelectField = require('components/form/SelectField');
var TextField = require('components/form/TextField');
var CheckCompletedLoanMixin = require('mixins/CheckCompletedLoanMixin');

var FormCreditCheck = React.createClass({
  mixins: [CheckCompletedLoanMixin],

  getInitialState: function() {
    var state = {};
    state.creditCheckAgree = this.props.loan.credit_check_agree;
    return state;
  },

  onChange: function(change) {
    $("html").addClass("loading");
    $.ajax({
      url: '/credit_checks/' + this.props.loan.id,
      method: 'PATCH',
      context: this,
      dataType: 'json',
      data: {
        credit_check: {
          credit_check_agree: change.target.checked
        }
      },
      success: function(response) {
        $("html").removeClass("loading");
        this.setState({creditCheckAgree: !this.state.creditCheckAgree});
        if (this.loanIsCompleted(response.loan)) {
          this.props.goToAllDonePage(response.loan);
        }
        else {
          this.props.setupMenu(response, 4);
        }
      }.bind(this),
      error: function(response, status, error) {
        $("html").removeClass("loading");
        this.setState({creditCheckAgree: false});
      }
    });
  },

  componentDidMount: function(){
    $("body").scrollTop(0);
  },

  render: function() {
    return (
      <div className='col-sm-9 col-xs-12 account-content'>
        <form className='form-horizontal credit-check'>
          <div className='form-group'>
            <p className='box-description col-sm-12'>
              We’re now ready to obtain your credit report in real time to verify your credit score and review your credit history. You won’t be charged for this service. Please authorize us by selecting the checkbox below.
            </p>
          </div>
          <div className='form-group'>
            <div className='col-sm-12'>
              <input type='checkbox' id='checkbox-borrower' disabled={!this.props.editMode} defaultChecked={this.state.creditCheckAgree} onChange={this.onChange}/>
              <label htmlFor='checkbox-borrower' className='customCheckbox blueCheckbox2'>I hereby authorize and instruct MortgageClub Corporation to obtain and review my credit report.</label>
            </div>
          </div>
        </form>
      </div>
    );
  },
});

module.exports = FormCreditCheck;
