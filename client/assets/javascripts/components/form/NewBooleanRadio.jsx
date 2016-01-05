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
      unknownLabel: 'Unknown'
    };
  },

  render: function() {
    var display = this.props.unknownLabel,
        customColumn = this.props.customColumn || "col-xs-6";

    if (this.props.checked) {
      display = this.props.yesLabel;
    } else if (this.props.checked === false) {
      display = this.props.noLabel;
    }

    return (
      <div>
        <h6>{this.props.label}</h6>
        <div className="row">
          <div className={customColumn}>
            <input type="radio" value="true" name={this.props.name} onChange={this.handleChange}
              checked={display === this.props.yesLabel} id={"true_" + this.props.keyName}/>

            <label htmlFor="own" className="customRadio">
              <span className="first-circle"><span className="second-circle"></span></span>
              {this.props.yesLabel}
            </label>
          </div>
          <div className={customColumn}>
            <input type="radio" value="false" name={this.props.name} onChange={this.handleChange}
              checked={display === this.props.noLabel} id={'false_' + this.props.keyName}/>
            <label htmlFor="own" className="customRadio">
              <span className="first-circle"><span className="second-circle"></span></span>{this.props.noLabel}
            </label>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = BooleanRadioView;
