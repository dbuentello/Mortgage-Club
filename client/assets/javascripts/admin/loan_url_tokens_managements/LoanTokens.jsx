var React = require("react/addons");
var ModalLink = require("components/ModalLink");
var clickedLoan = null;

var LoanTokens = React.createClass({
  getInitialState: function() {
    return {
      loans: this.props.bootstrapData.loans
    };
  },

  getLoanName: function(loan) {
    if(loan.subject_property && loan.subject_property.address && loan.subject_property.address.street_address != null) {
      var address = loan.subject_property.address.street_address;
    }
    else {
      var address = "Unknown Address";
    }
    return loan.user.first_name + " " + loan.user.last_name + " - " + address;
  },

  getBorrowerName: function(borrower) {
    if(borrower.user) {
      return borrower.user.full_name;
    }
    else {
      return "Unknown Borrower";
    }
  },

  getPreparedLoanUrlToken: function(token) {
    if(!token) {
      return;
    }

    return this.props.bootstrapData.url + "?reset_password_token=" + token;
  },

  onBorrowerChange: function(event) {
    var value = event.target.value;
    var filteredLoans = [];

    if(value == "All") {
      filteredLoans = this.props.bootstrapData.loans;
    }
    else {
      _.map(this.props.bootstrapData.loans, function(loan) {
        if(loan.user.id == value) {
          filteredLoans.push(loan);
        }
      });
    }

    this.setState({
      loans: filteredLoans
    });
  },

  generateToken: function() {
    $.ajax({
      url: "/loan_url_tokens",
      method: "POST",
      dataType: "json",
      data: {
        id: clickedLoan.id
      },
      success: function(response) {
        this.setState({
          loans: response.loans
        });
        $(".closeBtn").trigger("click");
      }.bind(this)
    });
  },

  rememberLoan: function(loan) {
    clickedLoan = loan;
  },

  render: function() {
    return (
      <div>
          {/* Page header */ }
      <div className="page-header">
        <div className="page-header-content">
          <div className="page-title">
            <h4><i className="icon-arrow-left52 position-left"></i> <span className="text-semibold">{"Loan's URL Token"}</span> - Management</h4>
          </div>
        </div>
      </div>
      {/* /page header */ }

      {/* Page container */ }
      <div className="page-container">

        {/* Page content */ }
        <div className="page-content">

          {/* Main content */ }
          <div className="content-wrapper">

            {/* Table */ }
            <div className="panel panel-flat">
              <div className="panel-body">
                <div className="row">
                  <div className="col-xs-3">
                    <label className="pan">
                      <span className="h7 typeBold">Borrower</span>
                    </label>
                    <select className="form-control loan-list" onChange={this.onBorrowerChange}>
                      <option value="All">All</option>
                      {
                        _.map(this.props.bootstrapData.borrowers, function(borrower) {
                          if (borrower.user) {
                            return (
                              <option value={borrower.user.id} key={borrower.id}>{this.getBorrowerName(borrower)}</option>
                            )
                          }
                        }, this)
                      }
                    </select>
                  </div>
                </div>
              </div>
              <div className="table-responsive">
                <table className="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Status</th>
                      <th>Borrower</th>
                      <th>URL Token</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                    _.map(this.state.loans, function(loan){
                      return (
                        <tr key={loan.id}>
                          <td nowrap>{this.getLoanName(loan)}</td>
                          <td>{loan.status}</td>
                          <td>{loan.user.email}</td>
                          <td>{this.getPreparedLoanUrlToken(loan.prepared_loan_token)}</td>
                          <th>
                            <a className="btn btn-primary btn-sm member-title-action" data-toggle="modal" data-target="#generateToken" onClick={_.bind(this.rememberLoan, this, loan)}>Generate Token</a>
                          </th>
                        </tr>
                        )
                      }, this)
                    }
                  </tbody>
                </table>
              </div>
            </div>
            {/* /table */ }

          </div>
          {/* /main content */ }

        </div>
        {/* /page content */ }

      </div>
      {/* /page container */ }
      <ModalLink
          id="generateToken"
          title="Confirmation"
          body="Are you sure to generate token for this loan?"
          yesCallback={this.generateToken}/>
    </div>
    );
  }
});

module.exports = LoanTokens;
