var React = require('react/addons');
var StaticFieldMixin = require('mixins/StaticFieldMixin');
var UpdateChangeMixin = require('mixins/UpdateChangeMixin');

var HelpTooltip = require('./HelpTooltip');

var BooleanRadioView = React.createClass({
  mixins: [UpdateChangeMixin, StaticFieldMixin],
  fieldType: 'boolean',

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the radio or the static text
    label: React.PropTypes.string, // field label

    // intitial state of the radio.
    checked: React.PropTypes.bool,

    // @tooltip is an object with properties `text` and `position`.
    // `position` is one of `top`, `right`, `bottom`, or `left`.
    // It is used to create a tooltip that will appear next to the
    // label text.
    tooltip: React.PropTypes.object,

    // if @onChange is provided, when user changes the radio, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the boolean value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    yesLabel: React.PropTypes.string,
    noLabel: React.PropTypes.string,
    unknownLabel: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      yesLabel: 'Yes',
      noLabel: 'No',
      unknownLabel: 'Unknown',
      tooltip: {}
    };
  },

  render: function() {
    var display = this.props.unknownLabel,
        tooltip = this.props.tooltip,
        hasTooltip = tooltip.hasOwnProperty('text') && tooltip.hasOwnProperty('position');

    if (this.props.checked) {
      display = this.props.yesLabel;
    } else if (this.props.checked === false) {
      display = this.props.noLabel;
    }

    return (
      <div>
        <label className="col-xs-12 pan">{this.props.label}</label>
        <div className="control-group mbs" style={{'display': this.props.editable ? null : 'none'}}>
          <label className="radio-inline mrm">
            <input type="radio" value='true' name={this.props.keyName} onChange={this.handleChange}
              checked={display === this.props.yesLabel} id={'true_' + this.props.keyName}/>
            {this.props.yesLabel}
          </label>
          <label className="radio-inline">
            <input type="radio" value='false' name={this.props.keyName} onChange={this.handleChange}
              checked={display === this.props.noLabel} id={'false_' + this.props.keyName}/>
            {this.props.noLabel}
          </label>
        </div>
        <p className="form-control-static" style={{'display': this.props.editable ? 'none' : null}}>
          {display}
          {hasTooltip ?
            <HelpTooltip position={tooltip.position} text={tooltip.text} />
          : null}
        </p>
      </div>
    );
  }
});

module.exports = BooleanRadioView;
