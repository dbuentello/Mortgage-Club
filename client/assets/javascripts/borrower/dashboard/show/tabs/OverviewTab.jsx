var _ = require('lodash');
var React = require('react/addons');
var TextFormatMixin = require('mixins/TextFormatMixin');

var ModalUpload = require('components/ModalUpload');
var ModalExplanation = require('components/ModalExplanation');


var OverviewTab = React.createClass({
  componentDidMount: function() {
    // $('.test').popover('show');
  },
  eachCheckList: function(checklist, i) {
    return (
      <CheckList
        key={checklist.id}
        index={i}
        loan={this.props.loan}
        borrower={this.props.borrower}
        checklist={checklist} />
    );
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
                {this.props.checklists.map(this.eachCheckList)}
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

    handleExplain: function() {
      alert("hanlde explain");
    },
    handleUpload: function() {
      alert("hanlde upload");
    },
    render: function() {
      var checklist = this.props.checklist;
      var status = checklist.status == "pending" ? "iconCancel" : "iconCheck";
      var button = checklist.checklist_type == "explain" ? "explain" : "upload"
      if (checklist.checklist_type == "explain") {
        return (
          <tr>
            <td><span className={status}></span></td>
            <td>{checklist.name}</td>
            <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
            <td>{this.isoToUsDate(checklist.due_date)}</td>
            <td>
              <button className="btn btnSml btnDefault" data-toggle="modal" data-target={"#" + button + "Box"}>
              Explain
              </button>

              <ModalExplanation
                id="explainBox"
                title="Generic Explanation"
                body="Explanation"
                loan={this.props.loan}
                yesCallback={this.handleExplain} />
            </td>
          </tr>
        );
      } else {
        return (
          <tr>
            <td><span className={status}></span></td>
            <td>{checklist.name}</td>
            <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
            <td>{this.isoToUsDate(checklist.due_date)}</td>
            <td>
              <button className="btn btnSml btnDefault" data-toggle="modal" data-target="#uploadBox">
              Upload
              </button>

              <ModalUpload
              id="uploadBox"
              title="Upload"
              loan={this.props.loan}
              borrower={this.props.borrower}
              checklist={checklist}
              yesCallback={this.handleUpload} />
            </td>
          </tr>
        );
      }
    }
});

