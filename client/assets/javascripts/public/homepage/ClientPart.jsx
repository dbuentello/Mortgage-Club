var React = require('react/addons');

var ClientPart = React.createClass({
  render: function() {

    return (
      <div className="content clientPart">
        <div className="container">
          <h1 className="text-uppercase client-header">meet our clients</h1>
          <h6 className="note">We work hard to provide our clients a painless mortgage experience and help them save time and money. </h6>

          <div className="clients row">
            <div className="client col-md-4 col-sm-4 col-xs-12 clearfix">
              <p>“We saved a ton of money on fees and our refinancing rate was great. We would highly recommend MortgageClub to our friends.”</p>
              <img src="/client1.png"/>
              <h4>Antonio & Nikki</h4>
              <h6>Alameda, CA</h6>
            </div>

            <div className="client col-md-4 col-sm-4 col-xs-12 clearfix">
              <p>“MortgageClub is a delight to work with. Within less than a month from the date of our application, we received a check for our loan.”</p>
              <img src="/client2.png"/>
              <h4>Vinh & Theresa</h4>
              <h6>Danville, CA</h6>
            </div>

            <div className="client col-md-4 col-sm-4 col-xs-12 clearfix">
              <p>“I chose MortgageClub because they had the lowest advertised rate and closing costs as I looked at several lenders.”</p>
              <img src="/client3.jpg"/>
              <h4>Paul</h4>
              <h6>San Mateo, CA</h6>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ClientPart;
