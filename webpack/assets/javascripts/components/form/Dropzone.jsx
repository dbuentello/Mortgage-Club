var React = require('react/addons');

var Dropzone = React.createClass({
  getDefaultProps: function() {
    return {
      supportClick: true,
      multiple: false
    };
  },

  getInitialState: function() {
    return {
      isDragActive: false
    }
  },

  propTypes: {
    onDrop: React.PropTypes.func.isRequired,
    style: React.PropTypes.object,
    field: React.PropTypes.object, // variables corresponding to this upload box
    supportClick: React.PropTypes.bool,
    accept: React.PropTypes.string,
    multiple: React.PropTypes.bool
  },

  onDragLeave: function(e) {
    this.setState({
      isDragActive: false
    });
  },

  onDragOver: function(e) {
    e.preventDefault();
    e.dataTransfer.dropEffect = "copy";

    this.setState({
      isDragActive: true
    });
  },

  onDrop: function(e) {
    e.preventDefault();

    this.setState({
      isDragActive: false
    });

    var files;
    if (e.dataTransfer) {
      files = e.dataTransfer.files;
    } else if (e.target) {
      files = e.target.files;
    }

    var maxFiles = (this.props.multiple) ? files.length : 1;
    for (var i = 0; i < maxFiles; i++) {
      files[i].preview = URL.createObjectURL(files[i]);
    }

    if (this.props.onDrop) {
      files = Array.prototype.slice.call(files, 0, maxFiles);
      this.props.onDrop(files, this.props.field);
    }

    // tooltip chosen box
    $(this.getDOMNode()).tooltip({
      title: files[0].name
    });

  },

  onClick: function () {
    if (this.props.supportClick === true) {
      this.open();
    }
  },

  open: function() {
    this.refs.fileInput.getDOMNode().click();
  },

  render: function() {

    var className = this.props.className || 'dropzone';
    if (this.state.isDragActive) {
      className += ' active';
    };

    var style = this.props.style || {
      borderStyle: this.state.isDragActive ? "solid" : "dotted"
    };

    return (
      React.createElement("div", {className: className, style: style, onClick: this.onClick, onDragLeave: this.onDragLeave, onDragOver: this.onDragOver, onDrop: this.onDrop},
      React.createElement("input", {style: {display: 'none'}, type: "file", multiple: this.props.multiple, ref: "fileInput", onChange: this.onDrop, accept: this.props.accept}),
        this.props.children
      )
    );
  }

});

module.exports = Dropzone;
