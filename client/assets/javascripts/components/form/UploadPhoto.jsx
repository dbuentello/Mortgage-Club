var React = require('react/addons');
var _ = require('lodash');

var UploadPhoto = React.createClass({
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
      btnText: 'Upload Photo',
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

  },

  handlePickFile: function(event) {
    this.setState({
      btnText: 'File was selected!'
    });
  },

  render: function() {
    return (
      <div>
        <label className="col-xs-12 pan" onChange={this.handlePickFile}>
          <span className='h7 typeBold'>{this.props.label}</span>
          <br/>
          <input ref='file' data-url={this.props.uploadUrl} className='hidden' name={this.props.name} type='file'/>
        </label>
      </div>
    );
  }
});

module.exports = UploadPhoto;
