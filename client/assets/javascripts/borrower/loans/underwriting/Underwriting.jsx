var _ = require('lodash');
var React = require('react/addons');

var timer;

var Underwriting = React.createClass({
  getInitialState: function() {
    return {
      percentCounter: 0
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
        break;
      default:
        break;
    }
  },

  render: function() {
    return (
      <div className='content container underwriting-text '>
        <div className='row mtl'>
          <div className='col-sm-5'>
            <div id="percent" className="percent outer">0%</div>
          </div>

          <div className='col-sm-6'>
            <div className="row1">
              <div id="status">Checking property eligibility</div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Underwriting;