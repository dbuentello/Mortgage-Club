/**
 * Component: Editor Element
 */
var React = require("react");
var ReactScriptLoader = require("react-script-loader");
var ReactScriptLoaderMixin = ReactScriptLoader.ReactScriptLoaderMixin;

var TinyMCEEditor = React.createClass({
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
    return "https://cdn.tinymce.com/4/tinymce.min.js";
  },

  onScriptLoaded: function() {
    tinyMCE.init({
      selector: "#text-editor",
      height: 300,
      plugins: [
        'advlist autolink lists link image charmap print preview anchor',
        'searchreplace visualblocks code fullscreen',
        'insertdatetime media table contextmenu paste code'
      ],
      toolbar: 'styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | link image',
      browser_spellcheck: true,
      contextmenu: false,
      setup:function(ed) {
        ed.on('change', function(e) {
          this.props.onChange(ed.getContent());
        }.bind(this));
      }.bind(this)
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

module.exports = TinyMCEEditor;