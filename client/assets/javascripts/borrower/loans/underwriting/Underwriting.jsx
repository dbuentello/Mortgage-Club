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
    timer = window.setInterval(this.incrementPercent, 100);
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
            loanErrors: response.errors,
            debugInfo: response.debug_info
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
    document.getElementById("debug_info").classList.remove("hidden");
    this.setState({
      validLoan: false
    });
  },

  backToLoan: function() {
    location.href = '/loans/' + this.props.bootstrapData.currentLoan.id + '/edit';
  },

  render: function() {
    return (
      <div className='content container'>
        <div id='underwriting' className='row mtl underwriting-text'>
          <div className='col-sm-5'>
            <div id="percent">0%</div>
          </div>

          <div className='col-sm-7'>
            <div className="row1">
              <div id="status">Checking property eligibility</div>
            </div>
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
            <a className='btn btnSml btnPrimary' onClick={this.backToLoan}>
              <i className='icon iconLeft mrl'/>
              Back to Loan
            </a>
          </div>
        </div>
        <div className='row hidden' id='debug_info'>
          { this.state.debugInfo
            ?
            <div>
              <ul>
                {
                  _.map(Object.keys(this.state.debugInfo), function(key){
                    if(key != "properties") {
                      return (
                        <li key={key}>{key}: {this.state.debugInfo[key]}</li>
                      )
                    }
                  }, this)
                }
              </ul>
              <h4>Properties:</h4>
              <ol>
                {
                  _.map(this.state.debugInfo.properties, function(property) {
                    return (
                      <li>
                        <ul>
                          <li>is_subject: {property.is_subject}</li>
                          <li>liability_payments: {property.liability_payments}</li>
                          <li>mortgage_payment: {property.mortgage_payment}</li>
                          <li>other_financing: {property.other_financing}</li>
                          <li>actual_rental_income: {property.actual_rental_income}</li>
                          <li>estimated_property_tax: {property.estimated_property_tax}</li>
                          <li>estimated_hazard_insurance: {property.estimated_hazard_insurance}</li>
                          <li>estimated_mortgage_insurance: {property.estimated_mortgage_insurance}</li>
                          <li>hoa_due: {property.hoa_due}</li>
                        </ul>
                      </li>
                    )
                  }, this)
                }
              </ol>
            </div>
            : null
            }
        </div>
      </div>
    )
  }
});

module.exports = Underwriting;