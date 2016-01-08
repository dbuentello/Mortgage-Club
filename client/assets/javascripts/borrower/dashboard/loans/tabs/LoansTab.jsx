var moment = require('moment');
var React = require('react/addons');

var LoansTab = React.createClass({
  eachLoan: function(loan, i) {
    return (
      <div className="col-sm-6 col-md-4" key={loan.id} index={i}>
        <div className="thumbnail">
          <div className="img-home"></div>
          <div className="caption">
            <h3></h3>
            <p><strong>Status:</strong> {loan.pretty_status}</p>
            <p><strong>Created at:</strong> {moment(loan.created_at).format('MMM DD, YYYY')}</p>
            <p><strong>Loan amount:</strong> {loan.amount}</p>
            <p><strong>Rate:</strong> {loan.interest_rate}%</p>
            <p>
              <a href={'/my/dashboard/' + loan.id} className="btn dashboard-btn" role="button">
                <img className="gear-icon" src="/icons/gear.png"/>
                <span>Dashboard</span>
              </a>
            </p>
          </div>
        </div>
      </div>
    );
  },
  render: function() {
    return (
      <div className="loanList mtl">
        <div className="row">
          {this.props.loans.map(this.eachLoan)}
        </div>
      </div>
    );
  }
});

module.exports = LoansTab;