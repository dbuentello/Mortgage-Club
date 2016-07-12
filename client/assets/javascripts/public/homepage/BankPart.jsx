/**
 * List of banks in homepage
 */
var React = require('react/addons');

var BankPart = React.createClass({
  render: function() {

    return (
      <div className="our-investors content">
        <hr/>
        <div className="container">
            <div className="row header-logo">
              <div className="col-xs-12 col-xs-offset-0 col-md-2  col-sm-6 col-sm-offset-4 col-md-offset-0 header-logo asseen">
                <div className="text-uppercase"><p>Our wholesale</p><p> investors</p></div>
              </div>
              <div className="col-md-8 col-xs-12">
                <div className="row">
                <div className="col-xs-6 col-md-3 col-sm-6  partner-logo">

                  <img src="/usbank_logo.png" />
                </div>
                <div className="col-xs-6 col-md-2 col-sm-6 partner-logo">
                  <img src="/remn_logo.png" />
                </div>
                <div className="col-xs-6 col-md-2 col-sm-6  partner-logo">

                    <img src="/pf_logo.png" />
                </div>
                <div className="col-xs-6 col-md-2 col-sm-6 partner-logo">

                    <img src="/interfirst.png" />
                </div>
                <div className="hidden-xs col-md-3 col-sm-6 col-sm-offset-3 col-md-offset-0 partner-logo">
                    <img src="/union_bank_logo.png" />
                </div>
                </div>
              </div>
              <div className="col-xs-12 col-xs-offset-0 col-md-2 col-sm-12 col-sm-offset-4 col-md-offset-0 asseen">
                <div className="text-uppercase"><p>And many</p><p>more</p></div>
              </div>
            </div>
        </div>
        <hr />

      </div>

    );
  }
});

module.exports = BankPart;
