var _ = require("lodash");
var React = require("react/addons");
var TextFormatMixin = require("mixins/TextFormatMixin");
var TextField = require("components/form/TextField");
var SelectField = require("components/form/SelectField");
var BooleanRadio = require('components/form/BooleanRadio');
var DateField = require('components/form/DateField');
var TinyMCEEditor = require("components/TinyMCEEditor");

var fields = {
  from: {label: "From", name: "from", keyName: "from"},
  to: {label: "To", name: "to", keyName: "to"},
  bcc: {label: "Bcc", name: "bcc", keyName: "bcc"},
  cc: {label: "Cc", name: "cc", keyName: "cc"},
  template: {label: "Template", name: "template", keyName: "template"},
  subject: {label: "Subject", name: "subject", keyName: "subject"}
};

var EmailDashboardTab = React.createClass({
  mixins: [TextFormatMixin],

  propTypes: {
    bootstrapData: React.PropTypes.object,
  },

  getInitialState: function() {
    return this.buildState(this.props.loan, this.props.property, this.props.loanMember, this.props.borrower, this.props.emailTemplates);
  },

  buildState: function(loan, property, loanMember, borrower, emailTemplates) {
    var state = {};

    state[fields.from.name] = loanMember.first_name + " " + loanMember.last_name + " <" + loanMember.email + ">";
    state[fields.to.name] = borrower.first_name + " " + borrower.last_name + " <" + borrower.user.email + ">";
    state[fields.bcc.name] = "";
    state[fields.cc.name] = "";
    state[fields.subject.name] = "";

    var templateOptions = [];
    templateOptions.push({name: 'Remind Checklists', value: emailTemplates.remind_checklists});
    state.templateOptions = templateOptions;
    state.body = "";
    return state;
  },

  onChange: function(change) {
    this.setState(change);
  },

  onBlur: function(blur) {
    this.setState(blur);
  },

  onSubmit: function(event) {
    event.preventDefault();
    this.setState({saving: true});

    var formData = new FormData();
    formData.append("from", this.state.from);
    formData.append("to", this.state.to);
    formData.append("bcc", this.state.bcc);
    formData.append("cc", this.state.cc);
    formData.append("body", this.state.body);
    formData.append("subject", this.state.subject);

    if($("#attachments")[0].files.length > 0){
      _.each($("#attachments")[0].files, function(file){
        formData.append("attachments[]", file);
      });
    }

    $.ajax({
      url: "/loan_members/dashboard/" + this.props.loan.id + "/send_email",
      data: formData,
      method: "POST",
      dataType: "json",
      contentType: false,
      processData: false,
      async: true,
      encType: "multipart/form-data",
      success: function(response) {
        this.setState({saving: false});
      }.bind(this),
      error: function(response){
        this.setState({saving: false});
      }.bind(this)
    });
  },

  updateEmailContent: function(content) {
    this.setState({body: content});
  },

  changeTemplate: function(change){
    var key = Object.keys(change)[0];
    var value = change[key];

    this.setState(change);
    this.updateEmailContent(value);
    tinyMCE.activeEditor.setContent(value);
  },

  render: function() {
    return (
      <div id="loan-terms-page">
        <div className="panel panel-flat">
          <div className="panel-heading">
            <h4 className="panel-title">Email Dashboard</h4>
          </div>
          <form className="form-horizontal form-checklist">
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.from.label}
                  keyName={fields.from.name}
                  value={this.state[fields.from.name]}
                  maxLength={11}
                  editable={false}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.to.label}
                  keyName={fields.to.name}
                  value={this.state[fields.to.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <TextField
                  label={fields.bcc.label}
                  keyName={fields.bcc.name}
                  value={this.state[fields.bcc.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
              <div className="col-sm-6">
                <TextField
                  label={fields.cc.label}
                  keyName={fields.cc.name}
                  value={this.state[fields.cc.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <SelectField
                  label={fields.template.label}
                  keyName={fields.template.name}
                  options={this.state.templateOptions}
                  editable={true}
                  onChange={this.changeTemplate}
                  value={this.state[fields.template.name]}
                  placeholder="Select template"/>
              </div>
              <div className="col-sm-6">
                <label className="col-xs-12 pan">
                  <span className="h7 typeBold">Attachments</span>
                  <input className="form-control typeWeightNormal input-sm" type="file" name="attachments" id="attachments" multiple />
                </label>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <TextField
                  label={fields.subject.label}
                  keyName={fields.subject.name}
                  value={this.state[fields.subject.name]}
                  onChange={this.onChange}
                  onBlur={this.onBlur}
                  maxLength={11}
                  editable={true}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <label className="col-xs-12 pan">
                  <span className="h7 typeBold">Body</span>
                </label>
                <TinyMCEEditor onChange={this.updateEmailContent} content={this.state.body}/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-6">
                <button className="btn btn-primary" id="submit-loan-terms" onClick={this.onSubmit} disabled={this.state.saving}>{ this.state.saving ? "Submitting" : "Submit" }</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    )
  }

});

module.exports = EmailDashboardTab;
