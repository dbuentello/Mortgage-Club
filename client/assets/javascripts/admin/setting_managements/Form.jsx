var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var ModalLink = require('components/ModalLink');
var TextEditor = require('components/TextEditor');

var Form = React.createClass({
  mixins: [FlashHandler],

  propTypes: {
    method: React.PropTypes.string,
    url: React.PropTypes.string,
    onReloadTable: React.PropTypes.func,
  },

  getDefaultProps: function() {
    return {
      method: 'POST',
      url: '',
      onReloadTable: null
    };
  },

  getInitialState: function() {
    if(this.props.Setting) {
      return {
        name: this.props.Setting.name,
        value: this.props.Setting.value,
      };
    }else {
      return {
        name: "",
        value: ""
      };
    }
  },

  onChange: function(event) {
    this.setState(event);
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-setting')[0]);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          question: response.setting.question,
          answer: response.setting.answer,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-setting">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Name"
                keyName="name"
                name="setting[name]"
                value={this.state.name}
                editable={false}/>

              <TextField
                label="Value"
                keyName="value"
                name="setting[value]"
                value={this.state.value}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
            </div>
          </div>
        </form>
      </div>
    )
  }
});

module.exports = Form;
