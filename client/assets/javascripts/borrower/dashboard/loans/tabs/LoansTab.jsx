var moment = require('moment');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var LoansTab = React.createClass({
  mixins: [TextFormatMixin],
  eachLoan: function(loan, i) {
    return (
      <div className="col-md-4 loan-item" key={loan.id} index={i}>
        <div className="loan-item-holder">
          <img className="img-responsive fixed-height-246" src={loan.subject_property.zillow_image_url ? loan.subject_property.zillow_image_url : "/home.jpg"}/>
          <div className="caption">
            <h3></h3>
            <p><strong>Status:</strong> {loan.pretty_status}</p>
            <p><strong>Create at:</strong> {moment(loan.created_at).format('MMM DD, YYYY')}</p>
            <p><strong>Loan amount:</strong> {this.formatCurrency(loan.amount, "$")}</p>
            <p><strong>Rate:</strong> {this.commafy(loan.interest_rate*100)}%</p>
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