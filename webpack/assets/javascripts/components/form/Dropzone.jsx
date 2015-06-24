var React = require('react/addons');

var Dropzone = React.createClass({
  getDefaultProps: function() {
    return {
      supportClick: true,
      multiple: false,
      download: false
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
    tip: React.PropTypes.string,
    fileUrl: React.PropTypes.string,
    removeUrl: React.PropTypes.string
  },

  componentDidMount: function() {
    this.setState({
      tip: this.props.tip || 'click to upload',
      dropzoneBox: this.refs.box.getDOMNode()
    });

    if (this.props.removeUrl != 'javascript:void(0)') {
      // having removeUrl means we already have document here, don't use fileUrl cause it's always there
      $(this.refs.box.getDOMNode()).css({backgroundColor: "#6B98F2", color: "#000"});
      $(this.refs.box.getDOMNode()).tooltip({ title: this.props.tip });
      this.setState({ fileUrl: this.props.fileUrl });
    } else {
      this.setState({ fileUrl: 'javascript:void(0)' });
    }
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

        // notify uploading
        $(this.refs.box.getDOMNode()).css({backgroundColor: "#81F79F", color: "#FF0000"});

        this.setState({ tip: 'Uploading ...' });

        $.ajax({
          url: this.props.uploadUrl,
          method: 'POST',
          enctype: 'multipart/form-data',
          data: formData,
          success: function(response) {
            // update tip after update
            this.setState({ tip: files[0].name });

            // update download button's href
            this.setState({ fileUrl: this.props.fileUrl });

            // tooltip chosen dropzone
            $(this.refs.box.getDOMNode()).tooltip({ title: files[0].name });

            // highltight chosen dropzone
            $(this.refs.box.getDOMNode()).css({backgroundColor: "#6B98F2", color: "#000"});

            // console.log(response.message);
          }.bind(this),
          cache: false,
          contentType: false,
          processData: false,
          async: true,
          error: function(response, status, error) {
            alert(error);
            return;
          }
        });
      }

      if (this.props.onDrop) {
        this.props.onDrop();
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

  remove: function() {
    if (this.state.tip != this.props.field.placeholder) {
      // notify uploading
      this.setState({ tip: 'Deleting ...' });
      $(this.refs.box.getDOMNode()).css({backgroundColor: "#FA8258", color: "#000"});

      $.ajax({
        url: this.props.removeUrl,
        method: 'DELETE',
        data: {
          order: this.props.orderNumber
        },
        dataType: 'json',
        success: function(response) {
          // update tip
          this.setState({ tip: this.props.field.placeholder });

          // disable the download button immediately
          this.setState({ fileUrl: 'javascript:void(0)' });

          // tooltip chosen dropzone
          $(this.refs.box.getDOMNode()).tooltip('destroy');

          // highltight chosen dropzone
          $(this.refs.box.getDOMNode()).css({backgroundColor: "#FFF", color: "#000"});

          // console.log(response.message);
        }.bind(this),
        error: function(response, status, error) {
          alert(error);
        }
      });
    }
  },

  render: function() {
    var className = 'col-xs-9 ';
    className += (this.props.className || 'dropzone');
    if (this.state.isDragActive) {
      className += 'active';
    };

    var style = this.props.style || {
      borderStyle: this.state.isDragActive ? 'solid' : 'dotted'
    };

    if (this.props.download) {
      var downloadButton = <a href={this.state.fileUrl} download><i className="iconDownload"></i></a>;
    } else {
      var downloadButton = <a href={this.state.fileUrl} target="_blank"><i className="iconDownload"></i></a>;
    }

    return (
      <div>
        <label className='col-xs-6'>
          <span className='h7 typeBold'>{this.props.field.label}</span>
        </label>
        <div className='col-xs-6'>
          <div className="row">
            <div ref='box' className={className} style={style} onClick={this.onClick} onDragLeave={this.onDragLeave}
              onDragOver={this.onDragOver} onDrop={this.onDrop}>
              <input style={{display: 'none'}} type="file" multiple={this.props.multiple} ref="fileInput"
                onChange={this.onDrop} accept={this.props.accept}>
              </input>
              <div className='tip'>
                {this.state.tip}
              </div>
            </div>
            <div className='action-icons'>
              {downloadButton}
              <a href='javascript:void(0)' onClick={this.remove} ><i className="iconTrash"></i></a>
            </div>
          </div>
        </div>
      </div>
    );
  }

});

module.exports = Dropzone;
