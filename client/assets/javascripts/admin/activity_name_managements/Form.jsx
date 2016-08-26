var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var TextEditor = require('components/TextEditor');
var ModalLink = require('components/ModalLink');

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
    if(this.props.ActivityName) {
      return {
        name: this.props.ActivityName.name,
        activity_type_id: this.props.ActivityName.activity_type_id,
        notify_borrower_email: this.props.ActivityName.notify_borrower_email,
        notify_borrower_text: this.props.ActivityName.notify_borrower_text,
        notify_borrower_email_subject: this.props.ActivityName.notify_borrower_email_subject,
        notify_borrower_email_body: this.props.ActivityName.notify_borrower_email_body || "",
        notify_borrower_text_body: this.props.ActivityName.notify_borrower_text_body
      };
    }else{
      return {
        name: "",
        activity_type_id: "",
        notify_borrower_email: false,
        notify_borrower_text: false,
        notify_borrower_email_subject: "",
        notify_borrower_email_body: "",
        notify_borrower_text_body: ""
      }
    }
  },

  onChange: function(event) {
    this.setState(event);
  },

  componentDidMount: function() {
    $("#notify_borrower_email").bootstrapSwitch();
    $('#notify_borrower_email').on('switchChange.bootstrapSwitch', function(event, state) {
      this.state.notify_borrower_email = !this.state.notify_borrower_email;
    }.bind(this));

    $("#notify_borrower_text").bootstrapSwitch();
    $('#notify_borrower_text').on('switchChange.bootstrapSwitch', function(event, state) {
      this.state.notify_borrower_text = !this.state.notify_borrower_text;
    }.bind(this));
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-acitivity-name')[0]);
    formData.append("activity_name[notify_borrower_text]", this.state.notify_borrower_text);
    formData.append("activity_name[notify_borrower_email]", this.state.notify_borrower_email);
    formData.append("activity_name[notify_borrower_email_body]", this.state.notify_borrower_email_body);
    formData.append("activity_name[activity_type_id]", this.state.activity_type_id);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          name: response.activity_name.name,
          activity_type_id: response.activity_name.activity_type_id,
          notify_borrower_text: response.activity_name.notify_borrower_text,
          notify_borrower_email: response.activity_name.notify_borrower_email,
          notify_borrower_text_body: response.activity_name.notify_borrower_text_body,
          notify_borrower_email_body: response.activity_name.notify_borrower_email_body,
          notify_borrower_email_subject: response.activity_name.notify_borrower_email_subject,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.activity_names){
          this.props.onReloadTable(response.activity_names);
        }
        this.setState({saving: false});
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

  onRemove: function(event) {
    if(this.props.ActivityName) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_activity_name_managements';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  onActivityTypeChange: function(event){
    this.setState({ activity_type_id: event.target.value});
  },

  updateEmailBody: function(content){
    this.setState({ notify_borrower_email_body: content})
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-acitivity-name">
          <div className="form-group">
            <div className='col-sm-4'>
              <label className='col-xs-12 pan'>
                <span className='h7 typeBold'>Activity Type</span>

                <select className='form-control loan-list' onChange={this.onActivityTypeChange}>
                  <option value=""></option>
                  {
                    _.map(this.props.ActivityTypes, function(activityType) {
                      return (
                        <option value={activityType.id} selected={activityType.id == this.state.activity_type_id ? 'selected' : ''} key={activityType.id}>{activityType.label}</option>
                      )
                    }, this)
                  }
                </select>
              </label>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Name"
                keyName="name"
                name="activity_name[name]"
                value={this.state.name}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-2">
              <label className="col-sm-12">
                <span className="h7 typeBold">Notify borrower by Sms</span><br/>
                <input type="checkbox" id="notify_borrower_text" data-on-color="success" data-off-color="default" data-on-text="Enable" data-off-text="Disable" className="switch" defaultChecked={this.state.notify_borrower_text} />
              </label>
            </div>
            <div className="col-sm-2">
              <label className="col-sm-12">
                <span className="h7 typeBold">Notify borrower by Email</span><br/>
                <input type="checkbox" id="notify_borrower_email" data-on-color="success" data-off-color="default" data-on-text="Enable" data-off-text="Disable" className="switch" defaultChecked={this.state.notify_borrower_email} />
              </label>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Text message body"
                keyName="notify_borrower_text_body"
                name="activity_name[notify_borrower_text_body]"
                value={this.state.notify_borrower_text_body}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Email subject"
                keyName="notify_borrower_email_subject"
                name="activity_name[notify_borrower_email_subject]"
                value={this.state.notify_borrower_email_subject}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-12">
              <label className="col-sm-12 pan">Email body</label>
              <TextEditor onChange={this.updateEmailBody} content={this.state.notify_borrower_email_body}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.ActivityName ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeActivityName" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeActivityName"
          title="Confirmation"
          body="Are you sure to remove this activity name?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
