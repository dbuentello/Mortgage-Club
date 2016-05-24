var React = require("react/addons");
var ModalLink = require("components/ModalLink");

var LoanUrlTokenTab = React.createClass({
  getInitialState: function() {
    return {
      loan: this.props.loan
    }
  },

  getPreparedLoanUrlToken: function(token) {
    if(!token) {
      return;
    }

    return this.props.url + "?reset_password_token=" + token;
  },

  generateToken: function() {
    $.ajax({
      url: "/loan_members/loan_url_tokens",
      method: "POST",
      dataType: "json",
      data: {
        id: this.props.loan.id
      },
      success: function(response) {
        this.setState({
          loan: response.loan
        });
        $(".closeBtn").trigger("click");
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div className="loan-url-token-page">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">{"Loan's URL Token"}</h4>
          </div>
          <div className="panel-body" style={{"margin-top":"20px"}}>
            <div className="row" style={{"margin-bottom": "10px"}}>
              <div className="col-xs-8">
                {this.getPreparedLoanUrlToken(this.state.loan.prepared_loan_token)}
              </div>
              <div className="col-xs-4">
                <a className="btn btn-primary btn-sm member-title-action" data-toggle="modal" data-target="#generateToken">Generate Token</a>
              </div>
            </div>
          </div>
        </div>
        <ModalLink
            id="generateToken"
            title="Confirmation"
            body="Are you sure to generate token for this loan?"
            yesCallback={this.generateToken}/>
      </div>
    );
  }
});

module.exports = LoanUrlTokenTab;
