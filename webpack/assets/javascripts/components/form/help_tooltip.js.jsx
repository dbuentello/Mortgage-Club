/**
 * @jsx React.DOM
 */

var UpdateChangeMixin = require('../../mixins/update_change_mixin');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var HelpTooltipView = React.createClass({
  mixins: [UpdateChangeMixin],

  propTypes: {
    // The text for the tooltip
    text: React.PropTypes.string,
    // One of `top`, `right`, `bottom`, or `left`
    position: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      position: 'right'
    };
  },

  componentDidMount: function() {
    $(this.getDOMNode()).tooltip({
      title:     this.props.text,
      placement: this.props.position
    });
  },

  componentDidUpdate: function() {
    $(this.getDOMNode()).tooltip('hide')
                      .attr('data-original-title', this.props.text);
  },

  render: function() {
    return (
      <span className="question" data-toggle="tooltip">?</span>
    );
  }
});

module.exports = HelpTooltipView;
