var React = require('react/addons');
var HelpTooltip = require('./HelpTooltip');
var _ = require('lodash');

var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');

var SelectField = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin],

  propTypes: {
    // determines if component should show the input box or the static text
    editable: React.PropTypes.bool,

    // field label
    label: React.PropTypes.string,

    // initial value
    value: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),

    // @tooltip is an object with properties `text` and `position`.
    // `position` is one of `top`, `right`, `bottom`, or `left`.
    // It is used to create a tooltip that will appear next to the
    // label text.
    tooltip: React.PropTypes.object,

    // @options is an array of objects with properties `name` and `value`.
    // It is used to build the options for the select input, and also to query for
    // the display text showed when the field is in read-only mode.
    options: React.PropTypes.arrayOf(React.PropTypes.object),

    // if true, a selectable blank option will be prepended to the list of options
    allowBlank: React.PropTypes.bool,

    // if @onChange is provided, when user select an option, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the selected value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    emptyStaticText: React.PropTypes.string,

    // set this to false if you want the field to have a red outline
    valid: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      allowBlank: false,
      placeholder: null,
      tooltip: {},
      valid: true
    };
  },

  getInitialState: function() {
    var options = this.props.options,
        selected;

    if (this.props.allowBlank) {
      // make sure we don't mutate the options array that get passed in
      options = _.union([{value: null, name: null}], options);
    }

    selected = _.findWhere(options, {value: this.props.value});
    return {
      name: selected ? selected.name : null,
      options: options
    };
  },

  updateState: function(event) {
    var selected = _.findWhere(this.state.options, {value: event.target.value});
    this.setState({
      name: selected ? selected.name : null
    });
  },

  handleFocus: function(event) {
    if (typeof this.props.onFocus == 'function') {
      this.props.onFocus();
    }
  },

  render: function() {
    var displayText = this.state.name,
        tooltip = this.props.tooltip,
        hasTooltip = tooltip.hasOwnProperty('text') && tooltip.hasOwnProperty('position'),
        classes = this.getFieldClasses(this.props.editable, this.props.isLarge, this.props.valid);

    classes.editableFieldClasses += ' placeholder';

    if (this.state.name === null && this.props.emptyStaticText) {
      displayText = this.props.emptyStaticText;
    }

    return (
      <div>
        <label className="col-xs-12 pan">
          <span className='h7 typeBold'>{this.props.label}</span>
          {hasTooltip ?
            <HelpTooltip position={tooltip.position} text={tooltip.text} />
          : null}
          <select className={classes.editableFieldClasses} name={this.props.name} onChange={this.handleChange} onFocus={this.handleFocus} value={this.props.value || ''}>
            {(this.props.placeholder) ? <option value="" disabled={true}>{this.props.placeholder}</option> : null}
            {this.state.options.map(function (option, i) {
              return (
                <option key={'select_' + (option.value || option.name) + i} value={option.value || ''}>{option.name}</option>
              );
            }, this)}
          </select>
        </label>
        <p className={classes.staticFieldClasses}>{displayText}</p>
      </div>
    );
  },

  componentWillReceiveProps: function(nextProps) {
    var options = nextProps.options,
        selected;

    if (nextProps.allowBlank) {
      // make sure we don't mutate the options array that get passed in
      options = _.union([{value: null, name: null}], options);
    }

    selected = _.findWhere(options, {value: nextProps.value});

    this.setState({
      name: selected ? selected.name : null,
      options: options
    });
  }
});

module.exports = SelectField;
