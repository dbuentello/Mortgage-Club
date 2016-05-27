var _ = require("lodash");
var React = require("react/addons");
var ModalLink = require("components/ModalLink");
var clickedLoan = null;

var LeadRequest = React.createClass({
  getInitialState: function() {
    return {
      loans: this.props.bootstrapData.loans,
      requestsState: this.buildStateForRequests(this.props.bootstrapData.sent_requests)
    };
  },

  buildStateForRequests: function(sentRequests) {
    var requestsState = [];

    _.map(sentRequests, function(request){
      requestsState[request.loan_id] = true;
    });

    return requestsState;
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

  request: function() {
    $.ajax({
      url: "/loan_members/lead_requests",
      method: "POST",
      dataType: "json",
      data: {
        id: clickedLoan.id
      },
      success: function(response) {
        this.setState({
          requestsState: this.buildStateForRequests(response.sent_requests)
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
      <div className="content container">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Lead Management</h4>
          </div>
        </div>
        <div className="datatable-scroll" id="checklists-table" style={{borderTop: "1px solid #ddd"}}>
          <table role="grid" className="table table-striped table-hover datatable-highlight dataTable no-footer">
            <thead>
              <tr role="row">
                <th  tabIndex="0" rowSpan="1" colSpan="1">Loan Name</th>
                <th  tabIndex="0" rowSpan="1" colSpan="1">Status</th>
                <th  tabIndex="0" rowSpan="1" colSpan="1">Action</th>
              </tr>
            </thead>
            <tbody>
              {
                _.map(this.state.loans, function(loan){
                  return (
                    <tr key={loan.id}>
                      <td nowrap>{this.getLoanName(loan)}</td>
                      <td>{loan.status}</td>
                      <td>
                        {
                          this.state.requestsState[loan.id] == true
                          ?
                          <a className="btn btn-primary btn-sm member-title-action disabled">Sent</a>
                          :
                          <a className="btn btn-primary btn-sm member-title-action" data-toggle="modal" data-target="#request" onClick={_.bind(this.rememberLoan, this, loan)}>Request</a>
                        }
                      </td>
                    </tr>
                  )
                }, this)
              }
            </tbody>
          </table>
        </div>
        <ModalLink
            id="request"
            title="Confirmation"
            body="Are you sure you want to claim this lead?"
            yesCallback={this.request}/>
      </div>
    );
  }
});

module.exports = LeadRequest;
