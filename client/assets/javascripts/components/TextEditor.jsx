var React = require("react");
var ReactScriptLoader = require("react-script-loader");
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var TextEditor = React.createClass({
  mixins: [ReactScriptLoaderMixin],

  getInitialState: function() {
    return {
      success: true
    }
  },

  getScriptURL: function() {
    return "http://cdn.ckeditor.com/4.5.6/full/ckeditor.js";
  },

  onScriptLoaded: function() {
    CKEDITOR.replace('text-editor', {
      width: "50%",
      height: 400
    });
  },

  onScriptError: function() {
    this.setState({success: false});
  },

  render: function() {
    return(
      <div className="editor">
        {
          this.state.success
          ?
          <textarea name="editor1" id="text-editor" rows="40" cols="50">
            This is my textarea to be replaced with CKEditor.
          </textarea>
          :
          <p>Cannot load text editor</p>
        }
      </div>
    )
  }
})

module.exports = TextEditor;