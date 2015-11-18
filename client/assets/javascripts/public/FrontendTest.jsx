var React = require('react/addons');

var FrontendTest = React.createClass({
  render: function() {
    var data = this.props.data;

    return (
      <section className='page-section pvxl'>
        <div className='container mtxl'>
          <div>
            <p>If you are interested in joining MortgageClub’s engineering team as a front end developer, we would love for you to have a go at the challenge below. This is a good chance for you to learn more about the stuff that we do, as well as for us to learn more about your coding style. This test should take about half a day to finish.</p>
            <p className='mbs'>
              Mortgages are so complicated that {"it's very hard for borrowers to choose the best loan program, even for experienced borrowers. By applying the Discounted Cash Flow model in finance to mortgages, we have come up with the True Cost of Mortgage model (patent-pending) to help borrowers choose the best loan program."}
            </p>
            <p className='mbs'>
              In this test, we’ll use ReactJS to implement a simple application to help borrowers choose the best loan program. It has these features:
            </p>
            <ul className='mbl'>
              <li>Display mortgage rates</li>
              <li>User is able to sort rates by <b>apr, monthly_payment, interest_rate</b></li>
              <li>
                Provide a "Help me choose" interface, it will allow user to do the following
                <ul>
                  <li>Adjust the years they plan to stay</li>
                  <li>Adjust investment return rate</li>
                  <li>Adjust effective tax rate</li>
                </ul>
              </li>
              <li>Based on user provided data, application displays best mortgage rate (select <b>a random loan program</b> for demo purpose)</li>
            </ul>
            <h5>Note: You can get rates from an endpoint: http://mortgageclub.io/home_test_rates</h5>
            <p className='mtl'>This is a sample user interface</p>
            <img src='http://s23.postimg.org/wf1jwqmyj/Screen_Shot_2015_11_16_at_5_24_44_PM.png'/>
            <img src='http://s4.postimg.org/t8dcb6nt9/Screen_Shot_2015_11_16_at_5_41_29_PM.png'/>
          </div>
        </div>
      </section>
    );
  }
});

module.exports = FrontendTest;
