var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');

var Dropzone = React.createClass({
  mixins: [FlashHandler],

  getDefaultProps: function() {
    return {
      supportClick: true,
      multiple: false,
      download: false,
      maxSize: 10000000,
      uploading: {
        backgroundColor: "#81F79F",
        color: "#FF0000"
      },
      uploaded: {
        backgroundColor: "#6B98F2",
        color: "#000"
      },
      removing: {
        backgroundColor: "#FA8258",
        color: "#000"
      },
      empty: {
        backgroundColor: "#FFF",
        color: "#000"
      },
      supportOtherDescription: false
    };
  },

  getInitialState: function() {
    return {
      isDragActive: false,
      otherDescription: ''
    }
  },

  propTypes: {
    onDrop: React.PropTypes.func,
    style: React.PropTypes.object,
    field: React.PropTypes.object, // variables corresponding to this upload box
    supportClick: React.PropTypes.bool,
    accept: React.PropTypes.string,
    multiple: React.PropTypes.bool,
    uploadUrl: React.PropTypes.string,
    tip: React.PropTypes.string,
    downloadUrl: React.PropTypes.string,
    removeUrl: React.PropTypes.string,
    maxSize: React.PropTypes.number,
    supportOtherDescription: React.PropTypes.bool
  },

  componentDidMount: function() {
    this.setState({
      tip: this.props.tip || 'click to upload',
      dropzoneBox: this.refs.box.getDOMNode()
    });

    if (this.props.removeUrl != 'javascript:void(0)') {
      // having removeUrl means we already have document here, don't use downloadUrl cause it's always there
      $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.uploaded.backgroundColor, color: this.props.uploaded.color});
      $(this.refs.box.getDOMNode()).tooltip({ title: this.props.tip });
      this.setState({ downloadUrl: this.props.downloadUrl });
      this.setState({ removeUrl: this.props.removeUrl });
    } else {
      this.setState({ downloadUrl: 'javascript:void(0)' });
      this.setState({ removeUrl: 'javascript:void(0)' });
    };
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
      // apply validation
      if (files[0].size > this.props.maxSize) {
        alert("Maximum file is 10MB. Please try again!");
        return;
      }

      if (!(files[0].type.match('text.*') || files[0].type.match('application.*')
        || files[0].type.match('image.*'))) {
        alert(files[0].type + " type is invalid. Only Document, Text and Image files are invalid!");
        return;
      }

      // users must enter their document's description if they upload other types.
      if (this.props.supportOtherDescription && this.state.otherDescription == '') {
        alert("You must enter the description.");
        return;
      }

      if (this.props.uploadUrl) {
        // prepare formData object
        var formData = new FormData();
        formData.append('file', files[0]);

        // Custom Params. Ex: var params = [{ "username": "Groucho"}];
        _.map(this.props.customParams, function(param) {
          var key = Object.keys(param)[0];
          var value = param[key];
          formData.append(key, value);
        });

        // Set other description
        if (this.state.otherDescription != '') {
          formData.append('description', this.state.otherDescription);
        }

        // Set original filename
        formData.append('original_filename', files[0].name);

        // notify uploading
        $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.uploading.backgroundColor, color: this.props.uploading.color});

        this.setState({ tip: 'Uploading ...' });

        $.ajax({
          url: this.props.uploadUrl,
          method: 'POST',
          enctype: 'multipart/form-data',
          data: formData,
          success: function(response) {
            // update tip after update
            this.setState({ tip: files[0].name });

            this.setState({ downloadUrl: response.download_url });
            this.setState({ removeUrl: response.remove_url });

            // tooltip chosen dropzone
            $(this.refs.box.getDOMNode()).tooltip({ title: files[0].name });

            // highltight chosen dropzone
            $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.uploaded.backgroundColor, color: this.props.uploaded.color});

            var flash = { "alert-success": "Uploaded successfully!" };
            this.showFlashes(flash);
            this.props.uploadSuccessCallback();
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

  onChangeDiscription: function(e) {
    if (this.props.supportOtherDescription) {
      this.setState({otherDescription: e.target.value})
    }
  },

  open: function() {
    this.refs.fileInput.getDOMNode().click();
  },

  remove: function() {
    if (this.state.tip != this.props.field.placeholder) {
      // notify removing
      this.setState({ tip: 'Deleting ...' });
      $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.removing.backgroundColor, color: this.props.removing.color});

      $.ajax({
        url: this.state.removeUrl,
        method: 'DELETE',
        dataType: 'json',
        success: function(response) {
          // update tip
          this.setState({ tip: this.props.field.placeholder });

          // disable the download button immediately
          this.setState({ downloadUrl: 'javascript:void(0)' });

          // tooltip chosen dropzone
          $(this.refs.box.getDOMNode()).tooltip('destroy');

          // highltight chosen dropzone
          $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.empty.backgroundColor, color: this.props.empty.color});

          // console.log(response.message);
          var flash = { "alert-success": "Removed successfully!" };
          this.showFlashes(flash);
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.error };
          this.showFlashes(flash);
        }
      });
    }
  },

  render: function() {
    var className = 'col-xs-9 ';
    className += (this.props.className || 'dropzone');
    // if (this.state.isDragActive) {
    //   className += ' active';
    // };

    var style = this.props.style || {
      borderStyle: this.state.isDragActive ? 'solid' : 'dotted'
    };

    if (this.props.download) {
      var downloadButton = <a href={this.state.downloadUrl} download><i className="iconDownload"></i></a>;
    } else {
      var downloadButton = <a href={this.state.downloadUrl} target="_blank"><i className="iconDownload"></i></a>;
    }

    if (this.props.supportOtherDescription) {
      var customDescription = <span><input className='mhl' placeholder='Description' onChange={this.onChangeDiscription}/></span>
    }

    return (
      <div>
        <label className='col-xs-6'>
          <span className='h7 typeBold'>{this.props.field.label}</span>
          {customDescription}
        </label>
        <div className='col-xs-6'>
          <div className="row">
            <div ref='box' className={className} style={style} onClick={this.onClick} onDragLeave={this.onDragLeave}
              onDragOver={this.onDragOver} onDrop={this.onDrop}>
              <input ref='fileInput' style={{display: 'none'}} type="file" multiple={this.props.multiple}
                onChange={this.onDrop} accept={this.props.accept} id={this.props.field.name} name={this.props.field.name}>
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
