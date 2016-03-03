var React = require('react/addons');

var BankPart = React.createClass({
  render: function() {

    return (
      <div class="home-footer content">
        <hr/>
        <div class="container">
            <div class="row header-logos">
              <div class="col-md-2  col-sm-6 col-sm-offset-4 col-md-offset-0 header-logo asseen">
                <div class="text-uppercase"><p>Our wholesale</p><p> investors</p></div>
              </div>
              <div class="col-md-8">
                <div class="row">
                <div class="col-md-3 col-sm-6  partner-logo">

                  <img src="/usbank_logo.png" />
                </div>
                <div class="col-md-2 col-sm-6 partner-logo">
                  <img src="/remn_logo.png" />
                </div>
                <div class="col-md-2 col-sm-6  partner-logo">

                    <img src="/pf_logo.png" />
                </div>
                <div class="col-md-2 col-sm-6 partner-logo">

                    <img src="/interfirst.png" />
                </div>
                <div class="col-md-3 col-sm-6 col-sm-offset-3 col-md-offset-0 partner-logo">

                    <img src="/union_bank_logo.png" />
                </div>
                </div>
              </div>
              <div class="col-md-1 col-sm-12 col-sm-offset-4 col-md-offset-0 header-logo asseen">
                <div class="text-uppercase"><p>And many</p><p>more</p></div>
              </div>
            </div>
        </div>
        <hr/>
      </div>

    );
  }
});

module.exports = BankPart;
