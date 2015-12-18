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
      otherDescription: '',
      fileIsExisting: false,
      downloadUrl: 'javascript:void(0)',
      removeUrl: 'javascript:void(0)'
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
    supportOtherDescription: React.PropTypes.bool,
    uploadSuccessCallback: React.PropTypes.func
  },

  componentDidMount: function() {
    this.setState({
      tip: this.props.tip || 'Upload',
    });

    if (this.fileIsExisting()) {
      $(this.refs.box.getDOMNode()).tooltip({ title: this.props.tip });
      this.setState({ downloadUrl: this.props.downloadUrl });
      this.setState({ removeUrl: this.props.removeUrl });
      this.setState({ fileIsExisting: true});
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
            this.setState({ fileIsExisting: true });
            // tooltip chosen dropzone
            $(this.refs.box.getDOMNode()).tooltip({ title: files[0].name });
            var flash = { "alert-success": "Uploaded successfully!" };
            this.showFlashes(flash);
            if (this.props.uploadSuccessCallback) {
              this.props.uploadSuccessCallback();
            }
          }.bind(this),
          cache: false,
          contentType: false,
          processData: false,
          async: true,
          error: function(response, status, error) {
            var flash = { "alert-danger": response.responseJSON.message };
            this.showFlashes(flash);
          }.bind(this)
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
    if (this.state.fileIsExisting) {
      // notify removing
      this.setState({ tip: 'Deleting ...' });

      $.ajax({
        url: this.state.removeUrl,
        method: 'DELETE',
        dataType: 'json',
        success: function(response) {
          // update tip
          this.setState({ tip: 'Upload' });

          // disable the download button immediately
          this.setState({ downloadUrl: null });

          this.setState({ fileIsExisting: false });

          // tooltip chosen dropzone
          $(this.refs.box.getDOMNode()).tooltip('destroy');

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

  fileIsExisting: function() {
    return this.props.removeUrl ? true : false;
  },

  render: function() {
    var style = this.props.style || {
      borderStyle: this.state.isDragActive ? 'solid' : 'dotted'
    };

    if (this.props.supportOtherDescription) {
      var customDescription = <span><input className='mhl' placeholder='Description' onChange={this.onChangeDiscription}/></span>
    }

    return (
      <div className='form-group'>
        <div className='col-md-6'>
          <h5>{this.props.field.label}</h5>
          {customDescription}
        </div>
        <div className='col-md-6'>
          <div ref='box' className='fileBtn'>
            {
              this.state.fileIsExisting
              ?
              <h5 className='fileBtnSmall file' onClick={this.onClick} onDragLeave={this.onDragLeave}
                onDragOver={this.onDragOver} onDrop={this.onDrop}>
                <img src='/icons/file.png'/>
                <span className="filename">{this.state.tip}</span>
                <input ref='fileInput' style={{display: 'none'}} type="file" multiple={this.props.multiple}
                  onChange={this.onDrop} accept={this.props.accept} id={this.props.field.name} name={this.props.field.name}>
                </input>
              </h5>
              :
              <h5 className='fileBtnSmall' onClick={this.onClick} onDragLeave={this.onDragLeave}
                onDragOver={this.onDragOver} onDrop={this.onDrop}>
                <img src='/icons/upload.png'/>{this.state.tip}
                <input ref='fileInput' style={{display: 'none'}} type="file" multiple={this.props.multiple}
                  onChange={this.onDrop} accept={this.props.accept} id={this.props.field.name} name={this.props.field.name}>
                </input>
              </h5>
            }
            <div>
              <a href={this.state.downloadUrl}>
                <img className='fileBtnSmall' src='/icons/download.png'/>
              </a>
              <img className='fileBtnSmall' src='/icons/trash.png' onClick={this.remove}/>
            </div>
          </div>
        </div>
      </div>
    );
  }

});

module.exports = Dropzone;
