var React = require('react/addons');
var FlashItem = require('components/FlashItem');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var FlashList = React.createClass({
  propTypes: {
    flashes: React.PropTypes.object
  },

  getDefaultProps: function() {
    return {
      flashes: {'alert-warning': 'save successfully'}
    };
  },

  render: function() {
    var flashitems = [];
    var flashes = this.props.flashes;
    var num = 1;

    for (var key in flashes) {
      var message = flashes[key];

      flashitems.push(<FlashItem msg_type={key} message={message} key={num}/>);
      num += 1;
    };

    return (
      <div>
        {flashitems}
      </div>
    );
  }
});

module.exports = FlashList;
