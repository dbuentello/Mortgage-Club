var moment = require("moment");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");

var LoansTab = React.createClass({
  mixins: [TextFormatMixin],
  eachLoan: function(loan, i) {
    return (
      <div className="col-md-4 loan-item" key={loan.id} index={i}>
        <div className="loan-item-holder">
          <a href={"/my/dashboard/" + loan.id}>
            <img className="img-responsive fixed-height-246" src={(this.props.commonInfo[loan.id] && this.props.commonInfo[loan.id].zillow_image_url) ? this.props.commonInfo[loan.id].zillow_image_url : "/default.jpg"}/>
          </a>
          <div className="caption">
            <a href={"/my/dashboard/" + loan.id}>
              <h6><strong>{this.props.commonInfo[loan.id] ? this.props.commonInfo[loan.id].address : ""}</strong></h6>
            </a>
            <p><strong>Status:</strong> {loan.pretty_status}</p>
            <p><strong>Create at:</strong> {moment(loan.created_at).format("MMM DD, YYYY")}</p>
            <p><strong>Loan amount:</strong> {this.formatCurrency(loan.amount, "$")}</p>
            <p><strong>Rate:</strong> {this.commafy(loan.interest_rate*100, 3)}%</p>
            {
              loan.pretty_status == "New"
              ?
                <p>
                  <a href={"/loans/" + loan.id + "/edit"} className="btn edit-app-btn" role="button">
                    <i className="iconPencil mrs"></i>
                    <span>Edit Application</span>
                  </a>
                </p>
              :
                <p>
                  <a href={"/my/dashboard/" + loan.id} className="btn dashboard-btn" role="button">
                    <img className="gear-icon" src="/icons/gear.png"/>
                    <span>Dashboard</span>
                  </a>
                </p>
            }
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