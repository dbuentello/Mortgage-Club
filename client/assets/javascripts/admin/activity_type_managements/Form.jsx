var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
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
    if(this.props.ActivityType) {
      return {
        label: this.props.ActivityType.label,
        type_name_mapping: this.props.ActivityType.type_name_mapping,
        type_name: "",
        order_number: this.props.ActivityType.order_number,
        notify_borrower_email: this.props.ActivityType.notify_borrower_email,
        notify_borrower_text: this.props.ActivityType.notify_borrower_text,
        notify_borrower_email_subject: this.props.ActivityType.notify_borrower_email_subject,
        notify_borrower_email_body: this.props.ActivityType.notify_borrower_email_body,
        notify_borrower_text_body: this.props.ActivityType.notify_borrower_text_body
      };
    }else{
      return {
        label: "",
        type_name_mapping: [],
        type_name: "",
        order_number: "",
        notify_borrower_email: false,
        notify_borrower_text: false,
        notify_borrower_email_subject: "",
        notify_borrower_email_body: "",
        notify_borrower_text_body: ""
      }
    }
  },

  onChange: function(event) {
    console.log(event);
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
    var formData = new FormData($('.form-loan-acitivity-type')[0]);
    _.each(this.state.type_name_mapping, function(type_name){
      formData.append("activity_type[type_name_mapping][]", type_name);
    });
    formData.append("activity_type[notify_borrower_text]", this.state.notify_borrower_text);
    formData.append("activity_type[notify_borrower_email]", this.state.notify_borrower_email);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          label: response.activity_type.label,
          type_name_mapping: response.activity_type.type_name_mapping,
          order_number: response.activity_type.order_number,
          notify_borrower_text: response.activity_type.notify_borrower_text,
          notify_borrower_email: response.activity_type.notify_borrower_email,
          notify_borrower_text_body: response.activity_type.notify_borrower_text_body,
          notify_borrower_email_body: response.activity_type.notify_borrower_email_body,
          notify_borrower_email_subject: response.activity_type.notify_borrower_email_subject,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.activity_types){
          this.props.onReloadTable(response.activity_types);
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
    if(this.props.ActivityType) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_activity_type_managements';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  addTypeNameMapping: function(event){
    var typeNameMapping = this.state.type_name_mapping.slice();
    typeNameMapping.push(this.state.type_name);

    this.setState({
      type_name_mapping: typeNameMapping
    });
  },

  removeTypeNameMapping: function(index){
    var typeNameMapping = this.state.type_name_mapping;
    typeNameMapping.splice(index, 1);

    this.setState({
      type_name_mapping: typeNameMapping
    });
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-acitivity-type">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Activity Type"
                keyName="label"
                name="activity_type[label]"
                value={this.state.label}
                editable={true}
                onChange={this.onChange}/>
            </div>
            <div className="col-sm-4">
              <TextField
                label="Order Number"
                keyName="order_number"
                name="activity_type[order_number]"
                value={this.state.order_number}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>

          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Activity Name"
                keyName="type_name"
                value={this.state.type_name}
                editable={true}
                onChange={this.onChange}/>
            </div>
            <div className="col-sm-2">
              <a className="btn btn-default" id="addTypeNameMapping" onClick={this.addTypeNameMapping} role="button">+</a>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              {
                _.map(this.state.type_name_mapping, function(type_name, index) {
                  return (
                    <div className="row input-sm">
                      <div className="col-sm-8 pan">
                        {type_name}
                      </div>
                      <div className="col-sm-4">
                        <a className="btn btn-danger" id="removeTypeNameMapping" onClick={this.removeTypeNameMapping.bind(this, index)} role="button">x</a>
                      </div>
                    </div>
                  )
                }, this)
              }
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
                name="activity_type[notify_borrower_text_body]"
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
                name="activity_type[notify_borrower_email_subject]"
                value={this.state.notify_borrower_email_subject}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Email body"
                keyName="notify_borrower_email_body"
                name="activity_type[notify_borrower_email_body]"
                value={this.state.notify_borrower_email_body}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.ActivityType ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeActivityType" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeActivityType"
          title="Confirmation"
          body="Are you sure to remove this activity type?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
