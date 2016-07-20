/**
 * List of steps to use this system (homepage)
 */
var React = require('react/addons');

var ClientPart = React.createClass({
  render: function() {

    return (
      <div className="content how-part">
        <div className="container">
          <h1 className="text-uppercase how-header">how it works</h1>
          <div className="row">
            <div className="col-md-6 clearfix how-item">
              <div className="bigNum">1</div>
              <div className="whyText">
                <h6>Apply</h6>
                <p>Spend 10 mins to give us your info, upload your documents, and we handle the rest. Our proprietary technology can extract data from your documents and public records to minimize manual data entry.</p>
              </div>
            </div>

            <div className="col-md-6 clearfix how-item">

              <img src="/HowItWorks_Step_1.jpg" style={{width: '75%'}}/>
            </div>
          </div>

          <div className="row">
            <div className="col-md-6 clearfix col-md-push-6 how-item">
              <div className="bigNum">2</div>
              <div className="whyText">
                <h6>Shop</h6>
                <p>Based on your info, we’ll show you the loan programs that you qualify for from over 50 lenders on our platform. Our algorithm can recommend the best loan for you and help you lock in the rate instantly. Lowest rate guaranteed, the rate you see is the rate you get.</p>
              </div>
            </div>
            <div className="col-md-6 clearfix col-md-pull-6 how-item">

              <img src="/HowItWorks_Step_2.jpg" style={{width: '75%'}}/>
            </div>
          </div>

          <div className="row">
            <div className="col-md-6 clearfix how-item">
              <div className="bigNum">3</div>
              <div className="whyText">
                <h6>Approve</h6>
                <p>We work with our wholesale investor to underwrite your loan application. This process includes an appraisal of your home and verification of your information. You can see what’s going on behind the scenes from your application dashboard in real-time.</p>
              </div>
            </div>

            <div className="col-md-6 clearfix how-item">

              <img src="/HowItWorks_Step_3.jpg" style={{width: '75%'}}/>
            </div>
          </div>

          <div className="row">
            <div className="col-md-6 clearfix col-md-push-6 how-item">
              <div className="bigNum">4</div>
              <div className="whyText">
                <h6>Close</h6>
                <p>Mortgage Club replaces manual processes and complicated paperwork with powerful software that cuts costs and reduces processing times. We can close your loan as fast as 15 days. We’ll work closely with escrow, title, and other parties to ensure you have a smooth closing.</p>
              </div>
            </div>
            <div className="col-md-6 clearfix col-md-pull-6 how-item">
              <img src="/HowFooterPic.png" />

            </div>
          </div>
        </div>
        <div id="how-footer"></div>
        </div>

    );
  }
});

module.exports = ClientPart;
