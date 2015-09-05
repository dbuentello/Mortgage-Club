var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var ModalUpload = require('components/ModalUpload');
var ModalExplanation = require('components/ModalExplanation');


var OverviewTab = React.createClass({
  componentDidMount: function() {
    // $('.test').popover('show');
  },

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

  updateChecklistStatus: function(checklist) {
    $.ajax({
      url: 'update_checklist_status',
      data: {
        checklist_id: checklist.id,
        status: 'done'
      },
      dataType: 'json',
      method: 'POST',
      context: this,
      success: function(response) {
        // do something
      }
    });
  },

  render: function() {
    var checklistCounter = this.props.checklists.length;
    var pendingCounter = 0;
    for (var i = 0; i < this.props.checklists.length; i++) {
      if (this.props.checklists[i].status == "pending") {
        pendingCounter += 1;
      }
    }
    var completeCounter = checklistCounter - pendingCounter;

    return (
      <div>
        <div className="box boxBasic backgroundBasic text-center">
          <div className='boxHead bbs'>
            <h4 className='typeBold'><i className="iconAttention"></i>&nbsp;
              We are still waiting on some of your checklist items
            </h4>
          </div>
          <div className="boxBody boxGuide">
            Go ahead and click 'Get Started' on the items below to start working through your open items
          </div>
        </div>

        <div className='text-center'>
          We display additional documents that user need to submit
        </div>

        <div className="box boxBasic backgroundBasic">
          <div className='boxHead bbs'>
            <h4 className='typeBold'>Your Loan Checklist &nbsp;
              <span className="label label-default">{completeCounter + "/" + checklistCounter}</span>
            </h4>

          </div>
          <div className="boxBody ptm">
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Status</th>
                  <th>Task</th>
                  <th>Info</th>
                  <th>Due</th>
                  <th>Action</th>
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
        status: this.props.checklist.status == "pending" ? "iconCancel" : "iconCheck"
      }
    },

    handleExplain: function() {
      alert("hanlde explain");
    },

    handleUpload: function() {
      alert("hanlde upload");
    },

    uploadSuccessCallback: function() {
      this.setState({
        status: 'iconCheck'
      });
      this.props.updateChecklistStatus(this.props.checklist);
    },

    getSubject: function(checklist) {
      if (checklist.document.subject_name == 'Borrower') {
        return this.props.loan.borrower;
      } else if (checklist.document.subject_name == 'Property') {
        return this.props.loan.property;
      } else if (checklist.document.subject_name == 'Closing') {
        return this.props.loan.closing;
      } else if (checklist.document.subject_name == 'Loan') {
        return this.props.loan;
      }
    },

    render: function() {
      var checklist = this.props.checklist;
      var button_id = checklist.checklist_type == "explain" ? ("explain-" + checklist.id) : ("upload-" + checklist.id);

      return (
        <tr>
          <td><span className={this.state.status}></span></td>
          <td>{checklist.name}</td>
          <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
          <td>{this.isoToUsDate(checklist.due_date)}</td>
          <td>
            { checklist.checklist_type == "explain" ?
                <div>
                  <button className="btn btnSml btnDefault" data-toggle="modal" data-target={"#" + button_id}>
                    Explain
                  </button>
                  <ModalExplanation
                    id={button_id}
                    title={checklist.name}
                    loan={this.props.loan}
                    checklist={checklist}
                    yesCallback={this.handleExplain} />
                </div>
                :
                <div>
                  <button className="btn btnSml btnDefault" data-toggle="modal" data-target={"#" + button_id}>
                    Upload
                  </button>
                  <ModalUpload
                    id={button_id}
                    title="Upload"
                    loan={this.props.loan}
                    borrower={this.props.borrower}
                    subject={this.getSubject(checklist)}
                    checklist={checklist}
                    yesCallback={this.handleUpload}
                    uploadSuccessCallback={this.uploadSuccessCallback}/>
                </div>
            }
          </td>
        </tr>
      );
    }
});

