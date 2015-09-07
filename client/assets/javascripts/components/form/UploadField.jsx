var React = require('react/addons');
var _ = require('lodash');

var UploadField = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    label: React.PropTypes.string,
    onUploadStart: React.PropTypes.func, // function called when the upload begins
    onDone: React.PropTypes.func, // function called with the response after the file upload is complete
    onFail: React.PropTypes.func, // function called if the upload fails for some reason
    title: React.PropTypes.string, // title of upload unit
    btnText: React.PropTypes.string, // text for button, default is 'Pick a file from your Computer'
    uploadUrl: React.PropTypes.string, // the endpoint to post the upload
    renderExtra: React.PropTypes.func, // function called to inject extra form fields after the title
    shouldHide: React.PropTypes.bool, // whether to hide the upload field, true means hide
    allowDrag: React.PropTypes.bool, // whether to allow files to be drag and dropped, true means yes
    delaySettingState: React.PropTypes.bool, // whether to use setTimeout to delay resetting the unit after success/failure
    showSecondaryButton: React.PropTypes.bool, // whether to show a secondary button
    secondaryButtonText: React.PropTypes.string, // text for the secondary button
    secondaryButtonClass: React.PropTypes.string, // className for the secondary button in addition to btn
    onSecondaryButtonClick: React.PropTypes.func, // function to call when the secondary button is clicked
  },

  getInitialState: function() {
    return {
      file: null,
      progress: null,
      btnText: 'Pick a file from your Computer',
    };
  },

  getDefaultProps: function() {
    return {
      title: null,
      onUploadStart: null,
      renderExtra: null,
      shouldHide: false,
      allowDrag: false,
      delaySettingState: true,
      showSecondaryButton: false,
      secondaryButtonClass: '',
    };
  },

  componentDidMount: function() {
    // var self = this;
    // this.$file = $(this.refs.file.getDOMNode());
    // console.dir(this.$file)
    // this.$file.fileupload({
    //   dataType: 'json',
    //   singleFileUploads: true,
    //   replaceFileInput: false,
    //   add: function(e, data) {
    //     var file;
    //     file = data.files[0];
    //     if (file.size > 50000000) {
    //       return bootbox.dialog({
    //         title: 'File too large',
    //         message: 'Attachment file size must be less than or equal to 50MB',
    //         buttons: {
    //           OK: {label: 'OK', className: 'btnPrimary'}
    //         }
    //       });
    //     } else {
    //       self.setState({file: file});
    //       if (self.props.onUploadStart) { self.props.onUploadStart(); }
    //       data.submit();
    //       self.setState({progress: 0});
    //     }
    //   },
    //   progress: function(e, data) {
    //     var progress;
    //     progress = Math.min(parseInt(data.loaded / data.total * 100, 10), 90);
    //     self.setState({progress: progress});
    //   },
    //   done: function(e, data) {
    //     self.setState({progress: 100});
    //     if (self.props.delaySettingState) {
    //       setTimeout(function() {
    //         self.setState({progress: null});
    //       }, 1000);
    //     } else {
    //       self.setState({progress: null});
    //     }
    //     self.props.onDone(data.result);
    //   },
    //   fail: function(e, data) {
    //     if (self.props.delaySettingState) {
    //       setTimeout(function() {
    //         self.setState({progress: null});
    //       }, 1000);
    //     } else {
    //       self.setState({progress: null});
    //     }
    //     self.props.onFail(data.jqXHR);
    //   }
    // });
  },

  handlePickFile: function(event) {
    this.setState({
      btnText: 'File was selected!'
    });
  },

  render: function() {
    return (
      <div>
        <label className="col-xs-12 pan">
          <span className='h7 typeBold'>{this.props.label}</span>
          <br/>
          <span className='btn btnSecondary link-file-upload col-xs-12' onChange={this.handlePickFile}>
            <span className='text-right'>{this.state.btnText}</span>
            <input ref='file' data-url={this.props.uploadUrl} className='hidden' name={this.props.name} type='file'/>
          </span>
        </label>
      </div>
    );
  }
});

module.exports = UploadField;
