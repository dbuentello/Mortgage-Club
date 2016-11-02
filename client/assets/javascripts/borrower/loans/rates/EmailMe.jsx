var _ = require('lodash');
var React = require('react/addons');
var TextField = require("components/form/NewTextField");
var ValidationObject = require("mixins/FormValidationMixin");
var TextEditor = require("components/TextEditor");
var TinyMCEEditor = require("components/TinyMCEEditor");

var email_me_fields = {
  firstName: {label: "First name", name: "email_me_first_name", keyName: "email_me_first_name", error: "emailMeFirstNameError", validationTypes: "empty"},
  lastName: {label: "Last name", name: "email_me_last_name", keyName: "email_me_last_name", error: "emailMeLastNameError",validationTypes: "empty"},
  email: {label: "Email", name: "email_me_email", keyName: "email_me_email", error: "emailMeEmail", validationTypes: "email"}
};

var EmailMe = React.createClass({
  mixins: [ValidationObject],

  componentDidMount: function() {
    if(this.props.userRole == "loan_member"){
      $("#email_me").on("shown.bs.modal", function(event){
        $.ajax({
          url: "/quotes/render_html",
          method: "POST",
          context: this,
          dataType: "json",
          data: {
            rate: this.props.quotes[$("#email_me_index").val()],
            code_id: this.props.codeId
          },
          success: function(response) {
            this.updateEmailContent(response.template);
            tinyMCE.activeEditor.setContent(response.template);
            // CKEDITOR.instances["text-editor"].setData(response.template);
          }.bind(this)
        });
      }.bind(this));
    }
  },

  getInitialState: function() {
    var state = {};
    state.email_me_inform = "";
    state.body = "";

    if(this.props.userRole == "loan_member"){
      email_me_fields.subject = {label: "Subject", name: "email_me_subject", keyName: "email_me_subject", error: "emailMeSubject", validationTypes: "empty"};
    }

    _.each(email_me_fields, function (field) {
      state[field.name] = null;
    });

    state.fields = email_me_fields;
    return state;
  },

  valid: function() {
    var isValid = true;
    var requiredFields = {};

    _.each(Object.keys(this.state.fields), function(key) {
      requiredFields[this.state.fields[key].error] = {value: this.state[this.state.fields[key].keyName], validationTypes: [this.state.fields[key].validationTypes]};
    }, this);

    if(!_.isEmpty(this.getStateOfInvalidFields(requiredFields))) {
      this.setState(this.getStateOfInvalidFields(requiredFields));
      isValid = false;
    }
    return isValid;
  },

  submitEmailMe: function(){
    if (this.valid() == false) {
      return false;
    }

    if(this.valid()){
      this.setState({isValid: true});
      $.ajax({
        url: "/quotes/email_me",
        method: "POST",
        dataType: "json",
        context: this,
        data: {
          email: this.state.email_me_email,
          rate: this.props.quotes[$("#email_me_index").val()],
          code_id: this.props.codeId,
          first_name: this.state.email_me_first_name,
          last_name: this.state.email_me_last_name,
          subject: this.state.email_me_subject,
          body: this.state.body
        },
        success: function(response) {
          this.setState({saving: true});
          this.setState({email_me_inform: "Thanks "+ this.state.email_me_first_name +", we've emailed you this rate quote." });
          $("#email_me").modal('hide');
          $("#email_me_inform").modal('show');
        },
        error: function(res) {
          this.setState({email_me_inform: "You can't send email right now. Please try again."});
          $("#email_me").modal('hide');
          $("#email_me_inform").modal('show');
        }
      });
    }
  },
  onChange: function (change) {
    this.setState(change);
  },
  onBlur: function(blur) {
    this.setState(blur);
  },
  updateEmailContent: function(content) {
    this.setState({body: content});
  },
  render: function() {
    return (
      <div>
        <div className="modal fade" id="email_me" tabIndex="-1" role="dialog" aria-labelledby="email_me_label">
          <div className="modal-dialog modal-md modal-large" role="document">
            <div className="modal-content">
              <span className="fa fa-times-circle closeBtn" data-dismiss="modal"></span>
              <div className="modal-body text-center container">
                <h2>{this.props.userRole == "loan_member" ? "Email Client" : "Email Me"}</h2>
                <h3 className="mc-blue-primary-text">{this.props.userRole == "loan_member" ? "Please give us your client info so we email them this rate quote." : "Please give us your info so we can email you this rate quote."}</h3>
                <form class="form-horizontal text-center" data-remote="true" id="new_email_me" action="/quotes/email_me" accept-charset="UTF-8" method="post">
                  <input type="hidden" id="email_me_index"/>
                  <div className="form-group">
                    <div className="col-md-4 col-sm-12 text-left">
                      <TextField
                        activateRequiredField={this.state[this.state.fields.firstName.error]}
                        label={this.state.fields.firstName.label}
                        keyName={this.state.fields.firstName.keyName}
                        value={this.state[this.state.fields.firstName.keyName]}
                        editable={true}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                    <div className="col-md-4 col-sm-12 text-left">
                      <TextField
                        activateRequiredField={this.state[this.state.fields.lastName.error]}
                        label={this.state.fields.lastName.label}
                        keyName={this.state.fields.lastName.keyName}
                        value={this.state[this.state.fields.lastName.keyName]}
                        editable={true}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                    <div className="col-md-4 col-sm-12 text-left">
                      <TextField
                        activateRequiredField={this.state[this.state.fields.email.error]}
                        label={this.state.fields.email.label}
                        keyName={this.state.fields.email.keyName}
                        value={this.state[this.state.fields.email.keyName]}
                        editable={true}
                        invalidMessage="Your input is not an email."
                        customClass={"account-text-input"}
                        validationTypes={["email"]}
                        onChange={this.onChange}
                        onBlur={this.onBlur}
                        editMode={true}/>
                    </div>
                    {
                      this.props.userRole == "loan_member"
                      ?
                        <div>
                          <div className="col-md-12 col-sm-12 text-left">
                            <TextField
                              activateRequiredField={this.state[this.state.fields.subject.error]}
                              label={this.state.fields.subject.label}
                              keyName={this.state.fields.subject.keyName}
                              value={this.state[this.state.fields.subject.keyName]}
                              editable={true}
                              onChange={this.onChange}
                              onBlur={this.onBlur}
                              editMode={true}/>
                          </div>
                          <div className="col-sm-1">
                            <h6>Body</h6>
                          </div>
                          <TinyMCEEditor onChange={this.updateEmailContent} content={this.state.body}/>
                        </div>
                      :
                        null
                    }
                  </div>
                  <div className="form-group text-center">
                    <div className="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-6 col-xs-offset-3" style={{"padding-bottom": "20px"}}>
                      <button type="button" onClick={this.submitEmailMe} className="btn btn-mc form-control" style={{"padding-top": "5px"}}>Send</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div className="modal fade" id="email_me_inform" tabIndex="-1" role="dialog" aria-labelledby="email_me_inform_label">
          <div className="modal-dialog modal-md" role="document">
            <div className="modal-content">
              <span className="fa fa-times-circle closeBtn" data-dismiss="modal"></span>
              <div className="modal-body text-center container">
                <h2>Email Me</h2>
                <h3 className="mc-blue-primary-text"><div dangerouslySetInnerHTML={{__html: this.state.email_me_inform}} /></h3>
                <form class="form-horizontal text-center" data-remote="true" id="new_email_me" action="/quotes/email_me" accept-charset="UTF-8" method="post">
                  <div className="form-group text-center">
                    <div className="col-md-6 col-md-offset-3" style={{"padding-top": "35px","padding-bottom": "20px"}}>
                      <a className="btn btn-mc form-control" style={{"padding-top": "5px"}} data-dismiss="modal">OK</a>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
module.exports = EmailMe;
