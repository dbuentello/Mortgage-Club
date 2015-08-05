var _ = require('lodash');
var React = require('react/addons');

var OverviewTab = React.createClass({
  render: function() {
    return (
      <div>
        <div className="box boxBasic backgroundBasic text-center">
          <div className='boxHead bbs'>
            <h3 className='typeBold'>We are still waiting on some of your checklist items</h3>
          </div>
          <div className="boxBody">
            Go ahead and click 'Get Started' on the items below to start working through your open items
          </div>
        </div>

        <div className='text-center'>
          We display additional documents that user need to submit
        </div>

        <div className="box boxBasic backgroundBasic">
          <div className='boxHead bbs'>
            <h3 className='typeBold'>Your Loan Checklist</h3>
          </div>
          <div className="boxBody">
            ...
          </div>
        </div>
      </div>
    )
  }
});

module.exports = OverviewTab;