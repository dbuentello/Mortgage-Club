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
    multiple: React.PropTypes.bool,
    uploadUrl: React.PropTypes.string,
    orderNumber: React.PropTypes.number,
    tip: React.PropTypes.string
  },

  componentDidMount: function() {
    var hasValue = false;
    if ( hasValue ) {
      $(this.getDOMNode()).css({color: "#000", width: 350});
    }

    this.setState({
      tip: this.props.tip || 'click to upload'
    });
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

    if (typeof files[0] !== 'undefined') {
      if (this.props.uploadUrl) {
        // prepare formData object
        var formData = new FormData();
        formData.append('file', files[0]);
        formData.append('order', this.props.orderNumber);

        var box = $(this.getDOMNode());

        // notify uploading
        $(box[0]).animate({width: 350}).
          css({backgroundColor: "#81F79F", color: "#FF0000"});

        this.setState({ tip: 'Uploading ...' });

        $.ajax({
          url: this.props.uploadUrl,
          method: 'POST',
          enctype: 'multipart/form-data',
          data: formData,
          success: function(response) {
            console.log(response.message);

            // tooltip chosen box
            $(box[0]).tooltip({ title: files[0].name });

            // highltight chosen box
            $(box[0]).animate({ width: 350 }).
              css({backgroundColor: "#6B98F2", color: "#000"});
          },
          cache: false,
          contentType: false,
          processData: false,
          async: true,
          error: function(response, status, error) {
            alert(error);
            return;
          }
        });

        // update tip after update
        this.setState({ tip: files[0].name });
      }

      if (this.props.onDrop) {
        this.props.onDrop(files, this.props.field);
      };
    }
  },

  onClick: function() {
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
      React.createElement("div", {className: 'tip'}, this.state.tip ),
        this.props.children
      )
    );
  }

});

module.exports = Dropzone;
