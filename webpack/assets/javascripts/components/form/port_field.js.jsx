/* global Bloodhound */

var TextFocusMixin = require('../../mixins/text_focus_mixin');

/**
 * # PortTypeAheadMixin
 * @requires vendor/plugins/typeahead.js
 * @uses `populatePorts` to initialize the Bloodhound data store
 *     before (or after if you render on server-side) you mount your component to DOM
 * @uses `initTypeAhead` to initialize the UI for the text field with a field name
 *     after your component has been mounted to the DOM
 * Note that when user selects an option, this mixin will automatically set the name of the
 * port to the component's `value` state. If you need to keep track of the selected option
 * within your component, use `this.state.value`.
 */
var PortTypeAheadMixin = {
  /**
   * ## populatePorts
   * Initializes a Bloodhound instance and store as `ports` member variable for future use.
   */
  populatePorts: function() {
    this.ports = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      prefetch: {
        url: '/ports.json',
        filter: function(list) {
          return _.map(list, function(port) {
            return {
              name: port
            };
          });
        }
      }
    });
    this.ports.initialize();
  },

  initTypeAhead: function() {
    this.$input = $(this.getDOMNode()).find('input');
    this.$input.typeahead({
      highlight: true
    }, {
      displayKey: 'name',
      source: this.ports.ttAdapter()
    });

    // hack to get around incompatibility between reactjs and typeahead
    this.$input.prev('input').removeAttr('data-reactid');

    // set state when user selects an option
    this.$input.on('typeahead:selected', function(event, selection) {
      var change = {};

      change[this.props.keyName] = selection.name;
      if (typeof this.props.onChange == 'function') {
        this.props.onChange(change);
      }
    }.bind(this));

    // Maybe set state when user blurs
    this.$input.on('blur', function(event) {
      if(event.target.value === "") {
        // Allow a deselect to happen
        var change = {};
        change[this.props.keyName] = '';
        if (typeof this.props.onChange == 'function') {
          this.props.onChange(change);
        }
      }
    }.bind(this));
  },

  componentDidMount: function() {
    this.populatePorts();
    this.initTypeAhead();
  },

  componentWillUnmount: function() {
    this.$input.typeahead('destroy');
  }

};

/**
 * PortField is a text field that has autosuggest for port names built-in.
 */
var PortInputView = React.createClass({
  mixins: [PortTypeAheadMixin, TextFocusMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label
    hidden: React.PropTypes.bool, // the entire component will be hidden if this is true
    value: React.PropTypes.string, // initial value for both input and static field.

    // if onChange is provided, when user changes the input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [portName]} where @keyName is from the props and `portName` is just the text value
    // in the input field.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
  },

  render: function() {
    return (
      <div className={this.props.hidden? 'hidden' : null}>
        <label className="col-xs-12 pan" style={{'display': this.props.editable ? null : 'none'}}>
          <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          <input className="form-control input-sm" type="text" onFocus={this.handleFocus} defaultValue={this.props.value} />
        </label>
        <div style={{'display': this.props.editable ? 'none' : null}}>
          <label className="col-xs-12 pan">
            <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          </label>
          <p className="form-control-static typeTruncate col-xs-12 pan">{this.props.value}</p>
        </div>
      </div>
    );
  }
});

module.exports = PortInputView;
