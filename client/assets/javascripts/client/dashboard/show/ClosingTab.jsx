var _ = require('lodash');
var React = require('react/addons');

var ClosingTab = React.createClass({
  render: function() {
    return (
      <div className="box boxBasic backgroundBasic">
        <div className='boxHead bbs'>
          <h3 className='typeBold plxl'>We are still waiting on some of your checklist items</h3>
        </div>
        <div className="boxBody ptm">
          Go ahead and click 'Get Started' on the items below to start working through your open items
        </div>
      </div>
    )
  }
});

module.exports = ClosingTab;