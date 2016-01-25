var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');
var ChecklistUpload = require('../ChecklistUpload');
var ChecklistExplanation = require('../ChecklistExplanation');


var OverviewTab = React.createClass({
  eachChecklist: function(checklist, i) {
    return (
      <CheckList
        key={checklist.id}
        index={i}
        loan={this.props.loan}
        borrower={this.props.borrower}
        checklist={checklist}
        updateChecklistStatus={this.updateChecklistStatus}/>
    );
  },

  getInitialState: function(){
    var checklistCounter = this.props.checklists.length;
    var pendingCounter = 0;
    for (var i = 0; i < this.props.checklists.length; i++) {
      if (this.props.checklists[i].status == "pending") {
        pendingCounter += 1;
      }
    }
    var completeCounter = checklistCounter - pendingCounter;
    return {
      pendingCounter: pendingCounter
    }
  },

  updateChecklistStatus: function(checklist) {
    var newPendingCounter = this.state.pendingCounter - 1;
    this.setState({
      pendingCounter: newPendingCounter
    });

    $.ajax({
      url: '/my/checklists/' + checklist.id,
      data: {
        checklist: {
          status: 'done'
        }
      },
      dataType: 'json',
      method: 'PATCH',
      context: this,
      success: function(response) {
      }
    });
  },
  render: function() {
    return (
      <div className="overviewTab">
        <div className="board sign-board overview">
          <div className="row">
            {
              (this.state.pendingCounter == 0)
              ?
                <div>
                  <div className="col-md-11">
                    <h4>Everything looks good!</h4>
                    <p>{"We'll let you know when we need your help to move forward."}</p>
                  </div>
                  <div className="col-md-1 dashboard-sign">
                    <span className="glyphicon glyphicon-ok"></span>
                  </div>
                </div>
              :
                <div>
                  <div className="col-md-11">
                    <h4>We are still waiting on some of your checklist items</h4>
                    <p>Go ahead and click 'Get Started' on the items below to start working through your open items</p>
                  </div>
                  <div className="col-md-1 dashboard-sign">
                    <img className="board-side" src="/warning-sign.png"/>
                  </div>
                </div>
            }
          </div>
        </div>
        <div className="board">
          <div className="board-header">
            <h2 className="board-title text-capitalize">your loan checklist</h2>
          </div>
          <div className="table-responsive">
            <table className="table table-condensed">
              <thead>
                <tr>
                  <th className="text-capitalize" width="10%">status</th>
                  <th className="text-capitalize" width="50%">task</th>
                  <th className="text-capitalize" width="8%">info</th>
                  <th className="text-capitalize" width="14%">due</th>
                  <th className="text-capitalize" width="18%">action</th>
                </tr>
              </thead>
              <tbody>
                {this.props.checklists.map(this.eachChecklist)}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
});

module.exports = OverviewTab;

var CheckList = React.createClass({
    mixins: [TextFormatMixin],

    getInitialState: function() {
      return {
        className: this.props.checklist.status == "pending" ? "glyphicon glyphicon-remove" : "glyphicon glyphicon-ok",
        logs: [],
        status: this.props.checklist.status,
      }
    },

    componentDidMount: function() {
      $('[data-toggle="popover"]').popover()
    },

    handleShowModal: function() {
      this.refs.modal.show();
    },

    handleExternalHide: function() {
      this.refs.modal.hide();
    },

    uploadSuccessCallback: function() {
      this.setState({
        className: 'glyphicon glyphicon-ok',
        status: 'done'
      });
      this.props.updateChecklistStatus(this.props.checklist);
    },

    getSubject: function(checklist) {
      if (checklist.subject_name == 'Borrower') {
        return this.props.loan.borrower;
      } else if (checklist.subject_name == 'Property') {
        return this.props.loan.subject_property;
      } else if (checklist.subject_name == 'Closing') {
        return this.props.loan.closing;
      } else if (checklist.subject_name == 'Loan') {
        return this.props.loan;
      }
    },

    render: function() {
      var checklist = this.props.checklist;
      var button_id = checklist.checklist_type == "explain" ? ("explain-" + checklist.id) : ("upload-" + checklist.id);

      return (
        <tr>
          <td><span className={this.state.className}></span></td>
          <td>{checklist.name}</td>
          <td>
            <button
              className="btnInfo"
              data-toggle="popover"
              data-trigger="focus"
              title="Enter the required entity information"
              data-content={checklist.info}>
              <span className="glyphicon glyphicon-info-sign"></span>
            </button>
          </td>
          <td>{this.isoToUsDate(checklist.due_date)}</td>
          <td>
            { checklist.checklist_type == "explain" ?
                <div>
                  <button className="btn dash-table-btn" onClick={this.handleShowModal} >
                    {this.state.status == "done" ? "Review" : "Explain"}
                  </button>
                  <ChecklistExplanation
                    ref="modal"
                    show={false}
                    id={button_id}
                    title={checklist.name}
                    loan={this.props.loan}
                    checklist={checklist}/>
                </div>
                :
                <div>
                  <button className="btn dash-table-btn" data-toggle="modal" data-target={"#" + button_id}>
                    {this.state.status == "done" ? "Review" : "Upload"}
                  </button>
                  <ChecklistUpload
                    id={button_id}
                    title="Upload"
                    loan={this.props.loan}
                    borrower={this.props.borrower}
                    checklist={checklist}
                    subject={this.getSubject(checklist)}
                    uploadSuccessCallback={this.uploadSuccessCallback}/>
                </div>
            }
          </td>
        </tr>
      );
    }
});
