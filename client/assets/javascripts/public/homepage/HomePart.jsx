var React = require('react/addons');

var HomePart = React.createClass({
  render: function() {
    var signupURL = "/auth/register/signup";
    return (
      <div className="content homePart">
        <div className="container">
          <div className="row">
            <div id="home-left" className="col-md-12">
              <div id="home-left-header"><h1>Always save time and money on your mortgage.</h1></div>
              <p className="lead">Apply in minutes. Shop all qualified loan programs. Lock in the best mortgage instantly.</p>
            </div>

            <div id="home-right" className="col-md-offset-3 col-md-6 rates">
              <div id="home-right-header">
                <h1 className="text-uppercase">
                  MORTGAGE RATES
                </h1>
                <p className="">(as of {this.props.bootstrapData.last_updated})</p>
              </div>
              <div className="row">

                <div className="col-12 col-sm-12 col-lg-12">
                <div className="wrapper">
       <div className="table-responsive borderless">
                  <table className="table homeTable">
                    <tr className="table-header">
                      <td>Programs</td><td>Mortgage Club</td><td>Wells Fargo</td><td>Quicken Loans</td>
                    </tr>
                    <tr className="table-content">
                      <td>30 Year Fixed<hr/></td>
                      <td>{this.props.bootstrapData.mortgage_aprs.loan_tek.apr_30_year}<hr/></td>
                      <td>{this.props.bootstrapData.mortgage_aprs.wellsfargo.apr_30_year}<hr/></td>
                      <td>{this.props.bootstrapData.mortgage_aprs.quicken_loans.apr_30_year}<hr/></td>
                    </tr>
                    <tr className="table-content">
                      <td>15 Year Fixed<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.loan_tek.apr_15_year}<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.wellsfargo.apr_15_year}<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.quicken_loans.apr_15_year}<hr/></td>
                    </tr>
                    <tr className="table-content">
                      <td>5/1 ARM<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.loan_tek.apr_5_libor}<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.wellsfargo.apr_5_libor}<hr/></td>
                        <td>{this.props.bootstrapData.mortgage_aprs.quicken_loans.apr_5_libor}<hr/></td>
                    </tr>
                  </table>
                </div>
                </div>
                </div>

              </div>

              <div>
                <a className="btn btn-lg theBtn text-uppercase" role="button" id="applyBtn" href={"/auth/register/signup"}>find my rate</a>
              </div>
            </div>
          </div>
        </div>
      </div>

    );
  }
});

module.exports = HomePart;
