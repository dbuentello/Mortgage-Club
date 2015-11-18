var React = require('react/addons');

var BackendTest = React.createClass({
  render: function() {
    var credit_score = "620";
    var housing_ratio = "0.28";
    return (
      <section className='page-section pvxl'>
        <div className='container mtxl'>
          <div>
            <img src='http://s10.postimg.org/6sgmwxfhl/logo.jpg'/>
            <p className='mtl'>If you are interested in joining MortgageClub’s engineering team as a Ruby on Rails developer, we would love for you to have a go at the challenge below. This is a good chance for you to learn more about the stuff that we do, as well as for us to learn more about your coding style. This test should take about half a day to finish.</p>
            <p className='mbs'>Mortgage underwriting in the United States is the process a lender uses to determine if the risk of offering a mortgage loan to a particular borrower under certain parameters is acceptable. In this take home test, we’ll use Rails to build a simple underwriting engine. The interface will allow users to create a loan with borrower and property info. Based on user provided data, the application will determine if loan is approved or not.</p>
            <h4>Underwriting has 3 steps</h4>
            <ol className='mbl'>
              <li>
                <b>Checking property eligibility</b>
                <p className='mbl'>If <b>property_type</b> is different from <b>single family, duplex, triplex, 4-plex, condo</b>, application displays an error message <i>"Sorry, your subject property is not eligible. We only offer loan programs for residential 1-4 units at this time."</i></p>
              </li>
              <li>
                <b>{"Verifying borrower's credit score"}</b>
                <p className='mbl'>{"If"} <b>credit_score</b> {"> 620, application displays an error message"} <i>"Sorry, your credit score is below the minimum required to obtain a mortgage."</i></p>
              </li>
              <li>
                <b>Verifying housing-expense ratio</b>
                <p className='mbl'>{"If"} <b>housing_expense_ratio</b> {"> 0.28, application displays an error message"} <i>"Your current housing expense is currently too high. We can't find any loan programs for you."</i></p>
              </li>
            </ol>
            <p>If the loan satisfies above conditions, the application should display a success message <i>"Congratulations, your loan was approved."</i></p>
            <h4>Underwriting formulas:</h4>
            <ul className='mbl'>
              <li><b>total_income</b> = base income + rental income + commission</li>
              <li><b>housing_expense_ratio</b> = (primary residence’s mortgage payment + primary residence’s mortgage insurance + primary residence’s homeowner’s Insurance + primary residence’s property tax + primary residence’s hoa due) / total income</li>
            </ul>
            <h5>Note: Writing test is compulsory and high test coverage is a big plus.</h5>
            <p className='mtl'>This is a sample user interface. Please note that the focus of this programming test is on the back-end stuff, you don’t need to spend too much time on the user interface.</p>


            <img src='http://s2.postimg.org/3silvhfex/primary_property.jpg'/>
            <img src='http://s8.postimg.org/c91ghtcf9/Screen_Shot_2015_11_17_at_10_12_37_AM.png'/>
          </div>
        </div>
      </section>
    );
  }
});

module.exports = BackendTest;
