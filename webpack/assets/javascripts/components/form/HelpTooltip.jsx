var React = require('react/addons');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var HelpTooltip = React.createClass({
  mixins: [UpdateChangeMixin],

  propTypes: {
    // The text for the tooltip
    text: React.PropTypes.string,
    // One of `top`, `right`, `bottom`, or `left`
    position: React.PropTypes.string,
    // background color class
    background: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      position: 'right',
      background: 'backgroundGreen'
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
      <span className={'circle xsm mvn typeReversed mls ' + (this.props.background || '')} data-toggle='tooltip'>?</span>
    );
  }
});

module.exports = HelpTooltip;
