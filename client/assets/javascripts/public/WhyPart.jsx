var React = require('react/addons');

var WhyPart = React.createClass({
  render: function() {

    return (
      <div className="content whyPart">
        <div className="container">
          <h1 className="text-uppercase white-header">Why us?</h1>
          <div className="row">
            <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why1.png") %>
              <div className="bigNum">1</div>
              <div className="whyText">
                <h6>Lowest Rate Guaranteed</h6>
                <p>We guarantee our rate is the lowest one for your mortgage scenario or we’ll send you a $200 gift card.</p>
              </div>
            </div>

            <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why2.png") %>
              <div className="bigNum">2</div>
              <div className="whyText">
                <h6>Save Time</h6>
                <p>By leveraging our technology, you can complete the loan application online in 10 mins and close your loan in 15 days.</p>
              </div>
            </div>
            <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why3.png") %>
              <div className="bigNum">3</div>
              <div className="whyText">
                <h6>Transparent</h6>
                <p>We provide an application dashboard so you can see what’s going on behind the scenes in real-time.</p>
              </div>
            </div>

            <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why4.png") %>
              <div className="bigNum">4</div>
              <div className="whyText">
                <h6>Personal Advice</h6>
                <p>Your Relationship Manager  is compensated by salary and bonus based on customer satisfaction to remove commission bias.</p>
              </div>
            </div>
                    <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why5.png") %>
              <div className="bigNum">5</div>
              <div className="whyText">
                <h6>100% Secured</h6>
                <p>You can be assured that we employ the highest level of security to protect your private information.</p>
              </div>
            </div>

            <div className="col-lg-6 clearfix whyItem">
              <%= image_tag("why6.png") %>
              <div className="bigNum">6</div>
              <div className="whyText">
                <h6>Always Select The Best Mortgage</h6>
                <p>Our team of finance and engineer geeks has developed a proprietary Trust Cost of Mortgage algorithm to help you select the best mortgage.</p>
              </div>
            </div>
          </div>


          </div>
      </div>



    );
  }
});

module.exports = WhyPart;
