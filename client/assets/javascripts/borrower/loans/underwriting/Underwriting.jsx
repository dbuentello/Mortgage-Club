var _ = require('lodash');
var React = require('react/addons');

var timer;

var Underwriting = React.createClass({
  getInitialState: function() {
    return {
      percentCounter: 0,
      validLoan: true
    }
  },

  componentDidMount: function() {
    timer = window.setInterval(this.incrementPercent, 200);
  },

  incrementPercent: function() {
    var counter = this.state.percentCounter + 1
    this.setState({
      percentCounter: counter
    });
    document.getElementById("percent").innerHTML = counter + "%";

    switch(counter) {
      case 10:
        document.getElementById("status").innerHTML = "Verifying borrower's credit score.";
        break;
      case 20:
        document.getElementById("status").innerHTML = "Verifying borrower's income.";
        break;
      case 30:
        document.getElementById("status").innerHTML = "Calculating debt-to-income ratio.";
        break;
      case 40:
        document.getElementById("status").innerHTML = "Verifying down payment and cash reserves";
        break;
      case 50:
        this.checkingLoan(this.props.bootstrapData.currentLoan.id);
        document.getElementById("status").innerHTML = "Calculating loan-to-value ratio";
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
          this.showErrors(response.errors);
        }
      }
    });
  },

  moveToRatesPage: function() {
    location.href = '/rates?loan_id=' + this.props.bootstrapData.currentLoan.id;
  },

  showErrors: function(errors) {
    window.clearInterval(timer);

    var full_error = errors.join("\n")
    document.getElementById("errors").innerHTML = full_error;
    this.setState({
      validLoan: false
    });
  },

  render: function() {
    return (
      <div className='content container'>
        <div className='row mtl underwriting-text'>
          <div className='col-sm-5'>
            <div id="percent" className="percent outer">0%</div>
          </div>

          <div className='col-sm-6'>
            <div className="row1">
              <div id="status">Checking property eligibility</div>
            </div>
          </div>
        </div>
        <div className='row mtl outer'>
          <div className='col-sm-12'>
            <div id='errors'></div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Underwriting;