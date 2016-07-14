/**
 * underwriting page to show percent of loading
 */

var _ = require('lodash');
var React = require('react/addons');

var timer;

var Underwriting = React.createClass({
  getInitialState: function() {
    return {
      percentCounter: 0,
      validLoan: true,
      loanErrors: []
    }
  },

  componentDidMount: function() {
    timer = window.setInterval(this.incrementPercent, 50);
    this.checkingLoan(this.props.bootstrapData.currentLoan.id);
  },

  incrementPercent: function() {
    var counter = this.state.percentCounter + 1
    this.setState({
      percentCounter: counter
    });
    document.getElementById("percent").innerHTML = counter + "%";

    switch(counter) {
      case 10:
        document.getElementById("status").innerHTML = "Verifying borrower's credit score";
        break;
      case 20:
        document.getElementById("status").innerHTML = "Verifying borrower's income";
        break;
      case 30:
        document.getElementById("status").innerHTML = "Calculating debt-to-income ratio";
        break;
      case 40:
        document.getElementById("status").innerHTML = "Verifying down payment and cash reserves";
        break;
      case 50:
        document.getElementById("status").innerHTML = "Calculating loan-to-value ratio";
        if (this.state.loanErrors.length > 0) {
          this.showErrors(this.state.loanErrors);
        }
        break;
      case 60:
        document.getElementById("status").innerHTML = "Verifying borrower's experience";
        break;
      case 70:
        document.getElementById("status").innerHTML = "Searching for eligible loan programs";
        break;
      case 85:
        document.getElementById("status").innerHTML = "Preparing loan programs to display";
        break;
      case 100:
        window.clearInterval(timer);
        this.moveToRatesPage();
        break;
      default:
        break;
    }
  },

  checkingLoan: function(loan_id) {
    $.ajax({
      url: '/underwriting/check_loan',
      data: {
        loan_id: loan_id
      },
      dataType: 'json',
      context: this,
      success: function(response) {
        if (response.message == 'ok') {
          this.setState({
            validLoan: true
          });
        } else {
          this.setState({
            loanErrors: response.errors
          });
          if (this.state.percentCounter >= 50) {
            this.showErrors(response.errors);
          }
        }
      },
      error: function(response, status, error) {
        console.log(error);
      }
    });
  },

  moveToRatesPage: function() {
    location.href = '/rates?loan_id=' + this.props.bootstrapData.currentLoan.id;
  },

  showErrors: function(errors) {
    window.clearInterval(timer);
    document.getElementById("underwriting").remove();

    var full_error = ""
    for (var i = 0; i < errors.length; i++) {
      full_error += "<li>" + errors[i] + "</li>"
    }
    document.getElementById("error").innerHTML = full_error;
    document.getElementById("errors").classList.remove("hidden");
    this.setState({
      validLoan: false
    });
  },

  backToLoan: function() {
    location.href = '/loans/' + this.props.bootstrapData.currentLoan.id + '/edit';
  },

  render: function() {
    return (
      <div className="content underwriting">
        <div className='content container' style={{"marginTop": "150px"}}>
          <div id='underwriting' className='row mtl underwriting-text'>
            <div className='col-sm-4'>
              <div id="percent">0%</div>
            </div>
            <div className='col-sm-8 text-xs-center'>
              <div id="status">Checking property eligibility</div>
            </div>
          </div>
          <div id='errors' className='row mtl hidden'>
            <div className='box mtn'>
              <div className='col-sm-3'></div>
              <div className='col-sm-6'>
                <div id='error'></div>
              </div>
              <div className='col-sm-3'></div>
            </div>

            <div className='box backToLoan'>
              <a className='btn edit-loan' onClick={this.backToLoan}>
                <i className='icon iconLeft mrl'/>
                Edit Loan Application
              </a>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Underwriting;
