var _ = require('lodash');
var React = require('react/addons');

var ModalUpload = require('components/ModalUpload');
var ModalExplanation = require('components/ModalExplanation');

var OverviewTab = React.createClass({
  componentDidMount: function() {
    // $('.test').popover('show');

  },
  handleUpload: function() {
    alert("hanlde upload");
  },
  handleExplain: function() {
    alert("hanlde explain");
  },
  render: function() {
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
              <span className="label label-default">14/17</span>
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
                <tr>
                  <td><span className="iconCheck"></span></td>
                  <td>Provide April bank statement</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><button className="btn btnSml btnDefault" data-toggle="modal" data-target="#uploadBox">Upload</button></td>
                </tr>
                <tr>
                  <td><span className="iconCancel"></span></td>
                  <td>Provide escrow/title agent information</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><a className="btn btnSml btnDefault" data-toggle="modal" data-target="#explainBox">Explain</a></td>
                </tr>
                <tr>
                  <td><span className="iconCancel"></span></td>
                  <td>Letter of explanation for credit inquires</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><a className="btn btnSml btnDefault" data-toggle="modal" data-target="#explainBox">Explain</a></td>
                </tr>
                <tr>
                  <td><span className="iconCheck"></span></td>
                  <td>Upload a copy of the executed purchase sales</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><button className="btn btnSml btnDefault" data-toggle="modal" data-target="#uploadBox">Upload</button></td>
                </tr>
              </tbody>
            </table>

          </div>
          <ModalUpload
            id="uploadBox"
            title="Upload"
            body="This is the upload mode"
            yesCallback={this.handleExplain} />
          <ModalExplanation
            id="explainBox"
            title="Generic Explanation"
            body="Explanation"
            loan={this.props.loan}
            yesCallback={this.handleUpload} />
        </div>
      </div>
    )
  }
});

module.exports = OverviewTab;