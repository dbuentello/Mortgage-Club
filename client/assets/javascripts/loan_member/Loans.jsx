var _ = require('lodash');
var React = require('react/addons');

var FlashHandler = require('mixins/FlashHandler');
var TextFormatMixin = require('mixins/TextFormatMixin');

var Loans = React.createClass({
  mixins: [FlashHandler, TextFormatMixin],
  getInitialState: function() {
    return ({
    });
  },

  componentDidMount: function() {
    $('.bootstrap-select').selectpicker();
    $('.bootstrap-select').change(this.handleLoanChanged);
  },

  handleLoanChanged: function(event) {
    var loan = $(event.currentTarget.classList)[0];
    loan = loan.substring(4, loan.length);
    this.setState({activeId: loan})
  },

  updateLoan: function(event) {
    var loan = $(event.currentTarget.classList)[0];
    loan = loan.substring(6, loan.length);
    var statusValue = $(".loan"+loan).val();
    $.ajax({
      url: "/loan_members/loans/"+loan,
      method: "put",
      dataType: "json",
      data: {
        status: statusValue
      },
      success: function(data) {
        this.setState({activeId: null});
      }.bind(this),
      error: function(response) {

      }
    });
  },

  render: function() {
    return (
      <div className='content container'>

          <div className="panel panel-flat">
            <div className="panel-heading">
              <h4 className="panel-title">Loans list</h4>
            </div>

            <div className="datatable-scroll" id="checklists-table" style={{borderTop: "1px solid #ddd"}}>
              <table role="grid" className="table table-striped table-hover datatable-highlight dataTable no-footer">
                <thead>
                  <tr role="row">
                    <th tabIndex="0" rowSpan="1" colSpan="1" aria-sort="ascending">Borrower</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Email</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Status</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Created at</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Updated at</th>
                    <th  tabIndex="0" rowSpan="1" colSpan="1">Action</th>
                  </tr>
                </thead>
                <tbody>

                  {
                    _.map(this.props.bootstrapData.loans, function(loan) {
                      return (
                        <tr key={loan.id}>
                          <td>{loan.user.to_s}</td>
                          <td>{loan.user.email}</td>
                          <td>

                            <select className={"loan" +loan.id + " loan-status bootstrap-select show-tick"} data-loanId={loan.id}>
                              {
                                _.map(this.props.bootstrapData.loan_statuses, function(status){
                                  var statusValue = status[0];
                                  var statusLabel = status[1];
                                  var isSelected = (statusValue === loan.status ? "selected" : null);
                                  return (
                                      <option value={statusValue} selected={statusValue === loan.status}>
                                        { statusLabel }
                                      </option>
                                    )
                                },this)
                              }
                            </select>
                            <span>
                              {
                                this.state.activeId == loan.id
                                ?
                                <span>
                                  &nbsp;
                                  <a onClick={this.updateLoan} className={"loanID"+loan.id + " btn-update-loan"}>
                                    <i className="icon-floppy-disk save-btn"></i></a>
                                </span>

                                :
                                <span>
                                &nbsp;
                                </span>
                              }
                            </span>

                          </td>
                          <td>{this.formatTime(loan.created_at)}</td>
                          <td>{this.formatTime(loan.updated_at)}</td>
                          <td><span>
                          <a className='linkTypeReversed' href={"/loan_members/dashboard/" + loan.id}
                            data-method='get'><i className="icon-pencil7"></i></a>
                          </span></td>

                        </tr>
                      )
                    }, this)
                  }
                </tbody>
              </table>
            </div>
          </div>


      </div>
    )
  }

});

module.exports = Loans;
