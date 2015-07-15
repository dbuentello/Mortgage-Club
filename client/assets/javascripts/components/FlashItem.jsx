var React = require('react/addons');

/**
 * HelpTooltipView renders a pretty little circle with a question mark that
 * displays a helpful tooltip when hovered over.
 */
var FlashItem = React.createClass({
  propTypes: {
    msg_type: React.PropTypes.string,
    message: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      msg_type: 'info',
      message: 'save successfully'
    };
  },

  onClick: function(e) {
    e.preventDefault();

    var node = this.getDOMNode().parentNode;
    React.unmountComponentAtNode(node);
    $(node).remove();
  },

  render: function() {
    var flashClasses = 'alert alert-dismissible ';
    flashClasses += this.props.msg_type;

    return (
      <div>
        <div className={flashClasses} role='alert'>
          <button type='button' className='close' aria-label='Close'>
            <span aria-hidden='true' onClick={this.onClick}>&times;</span>
          </button>
          {this.props.message}
        </div>
        {this.props.children}
      </div>
    );
  }
});

module.exports = FlashItem;
