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
    return this.buildState(this.props.loan, this.props.property, this.props.loanMember, this.props.borrower, this.props.emailTemplates, this.props.listEmails);
  },

  buildState: function(loan, property, loanMember, borrower, emailTemplates, listEmails) {
    var state = {};

    state[fields.from.name] = loanMember.first_name + " " + loanMember.last_name + " <" + loanMember.email + ">";
    state[fields.to.name] = borrower.user.email;
    state[fields.bcc.name] = "";
    state[fields.cc.name] = "";
    state[fields.subject.name] = "";

    var templateOptions = [];
    templateOptions.push({name: 'Remind Checklists', value: emailTemplates.remind_checklists});
    state.templateOptions = templateOptions;
    state.body = "";
    state.listEmails = listEmails;
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
    formData.append("loan_id", this.props.loan.id);
    formData.append("from", this.state.from);
    formData.append("to", this.state.to);
    formData.append("bcc", this.state.bcc);
    formData.append("cc", this.state.cc);
    formData.append("body", this.state.body);
    formData.append("subject", this.state.subject);

    var attachments = $("input[name=attachments]");
    if(attachments.length > 0){
      _.each(attachments, function(input){
        if(input.files.length > 0){
          _.each(input.files, function(file){
            formData.append("attachments[]", file);
          });
        }
      })
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
        this.setState({
          saving: false,
          listEmails: response.list_emails
        });
      }.bind(this),
      error: function(response){
        this.setState({saving: false});
      }.bind(this)
    });
  },

  addInputMore: function(){
    $("#attachment-label").after('<input class="form-control typeWeightNormal input-sm" style="margin-left: 10px" type="file" name="attachments" multiple/>');
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
      <div>
        <div className="tabbable tab-content-bordered">
          <ul className="nav nav-tabs nav-tabs-highlight nav-justified">
            <li className="active">
              <a href="#email-dashboard" data-toggle="tab" aria-expanded="true">Email Dashboard</a>
            </li>
            <li className="">
              <a href="#email-list" data-toggle="tab" aria-expanded="false">Sent Email</a>
            </li>
          </ul>

          <div className="tab-content">
            <div className="tab-pane has-padding active" id="email-dashboard">
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
                    <label className="col-xs-12 pan" id="attachment-label" style={{"margin-bottom": "0px"}}>
                      <span className="h7 typeBold">Attachments <a onClick={this.addInputMore} style={{"margin-left": "100px"}}>Add more</a></span>
                    </label>
                    <input className="form-control typeWeightNormal input-sm" type="file" name="attachments" multiple style={{"margin-left": "10px"}}/>
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

            <div className="tab-pane has-padding" id="email-list">
              <div className="datatable-scroll" id="checklists-table">
                <table role="grid" className="table table-hover datatable-highlight dataTable no-footer">
                  <thead>
                    <tr role="row">
                      <th tabIndex="0" rowSpan="1" colSpan="1" aria-sort="ascending">Recipient</th>
                      <th  tabIndex="0" rowSpan="1" colSpan="1">Subject</th>
                      <th  tabIndex="0" rowSpan="1" colSpan="1">Opened</th>
                      <th  tabIndex="0" rowSpan="1" colSpan="1">Clicked</th>
                      <th  tabIndex="0" rowSpan="1" colSpan="1">Sent</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      _.map(this.state.listEmails, function(message) {
                        return (
                          <tr key={message.id}>
                            <td>{message.to}</td>
                            <td>{message.subject}</td>
                            <td>{this.isoToUsDate(message.opened_at)}</td>
                            <td>{this.isoToUsDate(message.clicked_at)}</td>
                            <td>{this.isoToUsDate(message.created_at)}</td>
                          </tr>
                        )
                      }, this)
                    }
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

      </div>
    )
  }

});

module.exports = EmailDashboardTab;
