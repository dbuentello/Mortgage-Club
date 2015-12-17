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
    CKEDITOR.replace("text-editor", {
      width: "50%",
      height: 500,
      on: {
        change: function(event) {
          this.props.onChange(event.editor.getData());
        }.bind(this)
      }
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
          <div id="text-editor" dangerouslySetInnerHTML={{__html: this.props.content}}>
          </div>
          :
          <p>Cannot load text editor</p>
        }
      </div>
    )
  }
})

module.exports = TextEditor;