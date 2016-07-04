var moment = require("moment");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var ModalLink = require('components/ModalLink');
var FlashHandler = require('mixins/FlashHandler');
var _ = require('lodash');

var LoansTab = React.createClass({
  mixins: [TextFormatMixin],
  destroyLoan: function(loan_id) {
    $.ajax({
      url: '/loans/' + loan_id ,
      method: 'DELETE',
      dataType: 'json',
      success: function(response) {
        location.href = response.redirect_path;
      },
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);
      }.bind(this)
    });
  },
  eachLoan: function(loan, i) {
    return (
      <div className="col-md-4 col-sm-6 loan-item" key={loan.id} index={i}>
        <div className="loan-item-holder">
          <div className="hover-img">
            {
              loan.pretty_status == "New"
              ?
            <ModalLink
              id={loan.id}
              icon="fa fa-trash-o fa-2x trash-bd"
              title={null}
              class="btn delete-btn pull-right"
              bodyClass="mc-blue-primary-text"
              body="Are you sure you want to destroy this loan?"
              yesCallback={_.bind(this.destroyLoan, null, loan.id)}
            />
          : ""
          }

            <a href={"/my/dashboard/" + loan.id} className="img-link">
              <img src={(this.props.commonInfo[loan.id] && this.props.commonInfo[loan.id].zillow_image_url) ? this.props.commonInfo[loan.id].zillow_image_url : "/default.jpg"}/>
            </a>
          </div>
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
                  <a href={"/loans/" + loan.id + "/edit"} className="btn edit-app-btn btn-my-loan" role="button">
                    <i className="iconPencil mrs"></i>
                    <span>Edit Application</span>
                  </a>
              :
                  <a href={"/my/dashboard/" + loan.id} className="btn dashboard-btn btn-my-loan" role="button">
                    <img className="gear-icon" src="/icons/gear.png"/>
                    <span>Dashboard</span>
                  </a>
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
