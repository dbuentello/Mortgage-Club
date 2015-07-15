/**
 * @jsx React.DOM
 */
var marked = require('marked');

var StaticFieldMixin = require('../../mixins/static_field_mixin');
var UpdateChangeMixin = require('../../mixins/update_change_mixin');

/**
 * TextareaField renders an area field that can be converted between editable and read-only mode.
 */
var TextareaField = React.createClass({
  mixins: [StaticFieldMixin, UpdateChangeMixin],

  propTypes: {
    // determines if component should show the input box or the static text
    editable: React.PropTypes.bool,

    // field label
    label: React.PropTypes.string,

    // intitial value
    value: React.PropTypes.string,

    // number of rows
    rows: React.PropTypes.number,

    // if @onChange is provided, when user changes the text input, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [value]} where @keyName is from the props and `value` is the updated text value.
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,

    // whether the text is html
    isHtmlContent: React.PropTypes.bool,

    // whether the text should be processed with markdown when not editable
    isMarkdown: React.PropTypes.bool,

    // static text for null value, e.g. 'Unknown' or 'Not Provided'
    emptyStaticText: React.PropTypes.string
  },

  componentWillMount: function() {
    if(this.props.isMarkdown) {
      marked.setOptions({
        sanitize: true
      });
    }
  },

  getDefaultProps: function() {
    return {
      rows: 2,
      isHtmlContent: false,
      isMarkdown: false
    };
  },

  render: function() {
    var classes = this.getFieldClasses(this.props.editable, this.props.isLarge),
        displayText = this.props.value;

    if (displayText === null && this.props.emptyStaticText) {
      displayText = this.props.emptyStaticText;
    }

    if (!this.props.editable && this.props.isMarkdown) {
      displayText = marked(displayText);
    }

    return (
      <div>
        <label className="col-xs-12 pan">
          <span>{this.props.label}</span>
          <textarea className={classes.editableFieldClasses} value={this.props.value} rows={this.props.rows}
            onChange={this.handleChange} onFocus={this.handleFocus} placeholder={this.props.placeholder}/>
        </label>
        <div ref='htmlContent' className={classes.staticFieldClasses.replace('typeTruncate', '')} dangerouslySetInnerHTML={(this.props.isHtmlContent || this.props.isMarkdown) ? {__html: displayText} : null}>
          {(this.props.isHtmlContent || this.props.isMarkdown) ? null : displayText}
        </div>
      </div>
    );
  }
});

module.exports = TextareaField;
