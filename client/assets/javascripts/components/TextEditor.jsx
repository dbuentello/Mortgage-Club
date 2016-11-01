/**
 * Component: Editor Element
 */
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
    var type = this.props.type || "full";
    return "https://cdn.ckeditor.com/4.5.11/" + type + "/ckeditor.js";
  },

  onScriptLoaded: function() {
    var width = this.props.width || "50%";
    var height = this.props.height || "500px";
    CKEDITOR.replace("text-editor", {
      width: width,
      height: height,
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