var _ = require('lodash');
var React = require('react/addons');

var OverviewTab = React.createClass({
  componentDidMount: function() {
    // $('.test').popover('show');
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
            <h4 className='typeBold'>Your Loan Checklist</h4>
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
                  <td><button className="btn btnSml btnDefault">Upload</button></td>
                </tr>
                <tr>
                  <td><span className="iconCancel"></span></td>
                  <td>Provide escrow/title agent information</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><button className="btn btnSml btnDefault">Explain</button></td>
                </tr>
                <tr>
                  <td><span className="iconCheck"></span></td>
                  <td>Letter of explanation for credit inquires</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><button className="btn btnSml btnDefault">Explain</button></td>
                </tr>
                <tr>
                  <td><span className="iconCheck"></span></td>
                  <td>Upload a copy of the executed purchase sales</td>
                  <td><a className="test" role="button" data-toggle="popover" data-trigger="focus" title="Dismissible popover" data-content="And here's some amazing content. It's very engaging. Right?"><span className="iconInfo"></span></a></td>
                  <td>-</td>
                  <td><button className="btn btnSml btnDefault">Upload</button></td>
                </tr>
              </tbody>
            </table>

          </div>
        </div>
      </div>
    )
  }
});

module.exports = OverviewTab;