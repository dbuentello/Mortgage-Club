var _ = require('lodash');
var React = require('react/addons');

var Underwriting = React.createClass({

  render: function() {
    return (
      <div className='content container underwriting-text '>
        <div className='row mtl'>
          <div className='col-sm-5'>
            <div className="percent outer">86%</div>
          </div>
          <div className='col-sm-6'>
            <div className="design-row row1">
              <div className="text columns small-9">Checking property eligibility<span className="dots">.</span></div>
            </div>
            <div className="design-row row2">
              <div className="text columns small-9">Verifying borrower's credit score<span className="dots">.</span></div>
            </div>
            <div className="design-row row3">
              <div className="text columns small-9">Verifying borrower's income<span className="dots">.</span></div>
            </div>
            <div className="design-row row4">
              <div className="text columns small-9">Calculating debt-to-income ratio<span className="dots">.</span></div>
            </div>
            <div className="design-row row5">
              <div className="text columns small-9">Verifying down payment and cash reserves<span className="dots">.</span></div>
            </div>
            <div className="design-row row6">
              <div className="text columns small-9">Calculating loan-to-value ratio<span className="dots">.</span></div>
            </div>
            <div className="design-row row7">
              <div className="text columns small-9">Verifying borrower's experience<span className="dots">.</span></div>
            </div>
            <div className="design-row row8">
              <div className="text columns small-9">Searching for eligible loan programs<span className="dots">.</span></div>
            </div>
            <div className="design-row row9">
              <div className="text columns small-9">Preparing loan programs to display<span className="dots">.</span></div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = Underwriting;