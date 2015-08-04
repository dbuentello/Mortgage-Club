var _ = require('lodash');
var React = require('react/addons');

var ClosingTab = React.createClass({
  render: function() {
    return (
      <div className="box boxBasic backgroundBasic">
        <div className='boxHead bbs'>
          <h3 className='typeBold'>Closing Tab content</h3>
        </div>
        <div className="boxBody">
          ...
        </div>
      </div>
    )
  }
});

module.exports = ClosingTab;