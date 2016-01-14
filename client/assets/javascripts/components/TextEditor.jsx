var React = require("react");
var ReactScriptLoader = require("react-script-loader");
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var TextEditor = React.createClass({
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
      <label className="col-xs-12 pan">
        <span className='h7 typeBold'>{this.props.label}</span>
        <div className="editor pan">
          {
            this.state.success
            ?
            <div id="text-editor" dangerouslySetInnerHTML={{__html: this.props.content}}>
            </div>
            :
            <p>Cannot load text editor</p>
          }
        </div>
      </label>
    )
  }
})

module.exports = TextEditor;