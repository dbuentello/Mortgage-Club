/**
 * TODO: UNUSED CODE
 */

var EditSaveButtonView = React.createClass({
  propTypes: {
    // determines if the button should say 'Edit' or 'Save' or 'Saving'
    editable: React.PropTypes.bool,
    disabled: React.PropTypes.bool,

    // a link will be rendered if this is true
    isLink: React.PropTypes.bool,

    // if @onChange callback is provided, when user clicks on the button, the method will be invoked with
    // a boolean `editable` passed in as the single argument. The value of `editable` is the inverse of
    // the @editable prop.
    onChange: React.PropTypes.func
  },

  handleClick: function(event) {
    event.preventDefault();

    if (this.props.disabled) {
      return;
    }

    this.props.onChange(!this.props.editable);
  },

  render: function() {
    var btnText = (this.props.editable ? (this.props.disabled ? 'Saving' : 'Save') : 'Edit');
    var btnClass = 'btn btnPrimary pvxs phm';

    if (this.props.isLink) {
      btnClass = 'clickable';
    }

    return (
      <a className={btnClass} onClick={this.handleClick} disabled={this.props.disabled}>
        <span className='h6 phs'>{btnText}</span>
      </a>
    );
  }
});

module.exports = EditSaveButtonView;
