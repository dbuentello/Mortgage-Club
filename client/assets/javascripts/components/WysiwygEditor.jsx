/**
 * Component: Editor Element
 */
var React = require("react");
var ReactScriptLoader = require("react-script-loader");
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var WysiwygEditor = React.createClass({
  mixins: [ReactScriptLoaderMixin],

  propTypes: {
    label: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      success: true
    }
  },

  getScriptURL: function() {
    return "https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.3.5/js/froala_editor.min.js";
  },

  onScriptLoaded: function() {
    $("#text-editor").froalaEditor();
    $("#text-editor").on("froalaEditor.contentChanged", function (e, editor) {
      this.props.onChange(editor.html.get());
    }.bind(this));
  },

  onScriptError: function() {
    this.setState({success: false});
  },

  render: function() {
    return(
      <label className="col-xs-12 pan">
        <span className='h7 typeBold'>{this.props.label}</span>
        <div className="editor pan">
          {
            this.state.success
            ?
              <textarea id="text-editor">
              </textarea>
            :
            <p>Cannot load text editor</p>
          }
        </div>
      </label>
    )
  }
})

module.exports = WysiwygEditor;