var React = require('react/addons');
var HelpTooltip = require('./HelpTooltip');
var _ = require('lodash');

var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');
var ValidationField = require('./ValidationField');
var NewSelectField = React.createClass({
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
    var requiredMessage = this.props.requiredMessage || "This field is required";
    var unSelected = this.props.activateRequiredField&&(this.props.value==null || this.props.value==""|| this.props.value.trim()=="" || this.state.name==null || this.state.name.trim()=="")
    return (
      <div>
        <div className="col-md-6">
          <div className="select-box">
            <h6>{this.props.label}</h6>
            {
              this.props.helpText
              ?
                <p className="helpful-text">
                  <img src="/icons/info.png" />{this.props.helpText}
                </p>
              :
                null
            }
            <div>
              <select className="form-control" id={this.props.keyName} name={this.props.label} onChange={this.handleChange} onFocus={this.handleFocus} value={this.props.value || ''}>
                {(this.props.placeholder) ? <option value="" disabled={true}>{this.props.placeholder}</option> : null}
                {this.state.options.map(function (option, i) {
                  return (
                    <option key={'select_' + (option.value || option.name) + i} value={option.value || ''}>{option.name}</option>
                  );
                }, this)}
              </select>
              <img className="dropdownArrow" src="/icons/dropdownArrow.png" alt="arrow"/>
            </div>
          </div>
          <ValidationField id={this.props.keyName} activateRequiredField={this.props.activateRequiredField} value={this.props.value} title={requiredMessage}/>
        </div>
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

module.exports = NewSelectField;
