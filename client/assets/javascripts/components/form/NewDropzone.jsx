var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var ValidationField = require('./ValidationField');
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
      supportOtherDescription: false,
      delete: "yes"
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
    uploadSuccessCallback: React.PropTypes.func,
    removeSuccessCallback: React.PropTypes.func
  },

  componentDidMount: function() {
    this.setState({
      tip: this.props.tip || 'Click to upload',
    });

    if (this.fileIsExisting()) {
      //$(this.refs.box.getDOMNode()).tooltip({ title: this.props.tip });
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
            if(this.props.resetAfterUploading === true){
              this.setState({ tip: "Click to upload" });

              // disable the download button immediately
              this.setState({ downloadUrl: null, removeUrl: null });

              // destroy tooltip
              $(this.refs.box.getDOMNode()).tooltip('destroy');
              $(this.refs.box.getDOMNode()).css({backgroundColor: this.props.empty.backgroundColor, color: this.props.empty.color});

              // update description empty
              this.setState({ otherDescription: "" })
              $("#other_borrower_report").val('');
            } else {
              this.setState({ tip: files[0].name });

              this.setState({ downloadUrl: response.download_url });
              var removeUrl = this.props.delete == "no" ? response.remove_url + "?delete=no" : response.remove_url;

              this.setState({ removeUrl: removeUrl });
              this.setState({ fileIsExisting: true });
            }

            if (this.props.uploadSuccessCallback) {
              this.props.uploadSuccessCallback(this.props.field.name, files[0].name, response.id);
            }
          }.bind(this),
          cache: false,
          contentType: false,
          processData: false,
          async: true,
          error: function(response, status, error) {
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
    if (this.state.fileIsExisting && this.props.editMode !== false) {
      // notify removing
      this.setState({ tip: 'Deleting ...' });

      $.ajax({
        url: this.state.removeUrl,
        method: 'DELETE',
        dataType: 'json',
        success: function(response) {
          // update tip
          this.setState({ tip: 'Click to upload' });
          this.setState({ downloadUrl: "javascript:void(0)" });
          this.setState({ fileIsExisting: false });

          $("#" + this.props.field.name).val(null);

          if (this.props.removeSuccessCallback) {
            this.props.removeSuccessCallback(this.props.field.name);
          }
        }.bind(this),
        error: function(response, status, error) {
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
      var customDescription = <input style={{"width": "75%", "margin-bottom": "10px"}} placeholder='Description' onChange={this.onChangeDiscription} value={this.state.otherDescription}/>
    }

    var disabled = this.props.editMode === false ? "disabled" : null;

    return (
      <div className='form-group row'>
        <div className='col-md-6'>
          <h5>{this.props.field.label}</h5>
          {customDescription}
        </div>
        <div className='col-md-6' id={this.props.field.name + "_id"}>
          <div ref='box' className={disabled + ' row fileBtn'}>
            <table width="100%">
              <tr className="height-50">
                <td width="8%">
                  {
                      this.state.fileIsExisting
                      ?
                        <img src='/icons/file.png'/>
                      :
                        null
                  }
                </td>
                <td width="77%%">
                   {
                      this.state.fileIsExisting
                      ?
                        <h5 className='fileBtnSmall file' onClick={this.onClick} onDragLeave={this.onDragLeave}
                          onDragOver={this.onDragOver} onDrop={this.onDrop}>
                          <span className="filename">{this.state.tip}</span>
                          <input disabled={disabled} ref='fileInput' style={{display: 'none'}} type="file" multiple={this.props.multiple}
                            onChange={this.onDrop} accept={this.props.accept} id={this.props.field.name} name={this.props.field.name}>
                          </input>
                        </h5>
                      :
                        <h5 className='fileBtnSmall' onClick={this.onClick} onDragLeave={this.onDragLeave}
                          onDragOver={this.onDragOver} onDrop={this.onDrop}>
                          <img src='/icons/upload.png' className="iconUpload"/>
                            <span className="no-file-name">{this.state.tip}</span>

                          <input disabled={disabled} ref='fileInput' style={{display: 'none'}} type="file" multiple={this.props.multiple}
                            onChange={this.onDrop} accept={this.props.accept} id={this.props.field.name} name={this.props.field.name}>
                          </input>
                        </h5>
                    }
                </td>
                <td width="15%">
                  <a href={this.state.downloadUrl} className="icon-download">
                    <img src='/icons/download.png'/>
                  </a>
                  <a className="icon-trash">
                    <img src='/icons/trash.png' onClick={this.remove}/>
                  </a>
                </td>
              </tr>
            </table>
          </div>
          <ValidationField id={this.props.field.name + "_id"} activateRequiredField={this.props.activateRequiredField} value={this.state.downloadUrl} requiredMessage={"This field is required"}/>
        </div>
      </div>
    );
  }

});

module.exports = Dropzone;
