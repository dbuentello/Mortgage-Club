var moment = require('moment');
var React = require('react/addons');

var LoansTab = React.createClass({
  eachLoan: function(loan, i) {
    return (
      <div className="col-sm-6 col-md-4" key={loan.id}>
        <div className="thumbnail">
          <div className="img-home"></div>
          <div className="caption">
            <h3>{loan.property.address.address}</h3>
            <p>Status: Finishing</p>
            <p>Created at: {moment(loan.created_at).format('MMM DD, YYYY')}</p>
            <p>Loan amount: {loan.amount}</p>
            <p>Rate: {loan.interest_rate}%</p>
            <p>
              <a href={'/my/dashboard/' + loan.id} className="btn btn-primary" role="button">
                <i className='iconCog mrxs'/>
                Dashboard
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