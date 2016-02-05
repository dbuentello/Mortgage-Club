var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");

var RateAlert = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function() {
    return {
      phoneNumber: null,
      labelUpload: "Upload your mortgage statement"
    }
  },

  handleFileChange: function(event){
    var name = $("#uploadFile")[0].files[0].name;

    this.setState({labelUpload: (name.length > 30 ? name.substr(0, 30) + "..." : name)});
  },

  handleSubmit: function(event){
    $("[data-toggle='tooltip']").tooltip("destroy");
    event.preventDefault();

    var form = document.forms.namedItem("fileinfo");
    var formData = new FormData(form);

    $.ajax({
      url: "/potential_users",
      data: formData,
      method: "POST",
      encType: "multipart/form-data",
      dataType: "json",
      success: function(response) {
        this.setState({isSuccess:true});
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response){
        console.dir(response.responseJSON)
        this.setState({
          emailError: response.responseJSON.email,
          phoneNumberError: response.responseJSON.phone_number,
          documentError: response.responseJSON.mortgage_statement,
          alertMethodError: response.responseJSON.alert_method,
        })
      }.bind(this)
    });
  },

  changePhoneNumber: function(event) {
    var phoneNumber = this.formatPhoneNumber(event.target.value);
    this.setState({phoneNumber: phoneNumber});
  },

  componentDidUpdate: function() {
    if(event.target.id != "phone_number") {
      this.renderTooltip();
    }
  },

  componentDidMount: function(event) {
    this.renderTooltip();
  },

  renderTooltip: function() {
    $("[data-toggle='tooltip']").tooltip({
      placement: "left",
      trigger: "manual"
    }).tooltip("show");
  },

  render: function() {
    var uploadUrl = "/potential_users/mortage_statement/upload";

    return (
      <div className="rate-alert">
        <div className="rate-alert-form">
          <div className="container">
            {
              this.state.isSuccess
              ?
                <div className="col-md-12 text-center">
                  <div className="thank-you">
                    <h1>Thank you for setting rate alert!</h1>
                    <p>Keep an eye out for our email and/or text message soon.</p>
                    <img src="/rate_alert.png"/>
                  </div>
                </div>
              :
                <div className="mtl">
                  <div className="col-md-8 col-md-offset-2">
                    <h1>RATE ALERT</h1>
                    <p>{"Please upload your latest mortgage statement so our software can start tracking your mortgage rates. We'll alert you as soon as you can save money by refinancing with Mortgage Club (after accounting for closing costs)!"}</p>
                  </div>
                  <div className="col-md-12 col-md-offset-4">
                    <form className="potential-users form-horizontal text-center" action="/potential_users" type="json" enctype="multipart/form-data" method="post" name="fileinfo">
                      <div className="form-group">
                        <div className="col-sm-5 email-address">
                          <h5 className="text-left">Email Address</h5>
                          <input type="email" className="form-control" name="potential_user[email]"
                            id="email" data-toggle="tooltip" data-original-title={this.state.emailError}/>
                          <img src="/icons/mail.png" alt="title"/>
                        </div>
                      </div>
                      <div className="form-group">
                        <div className="col-sm-5 phone-number">
                          <h5 className="text-left">Phone Number (optional)</h5>
                          <input type="text" className="form-control" name="potential_user[phone_number]" id="phone_number" value={this.state.phoneNumber} onChange={this.changePhoneNumber}
                            data-toggle="tooltip" data-original-title={this.state.phoneNumberError}/>
                          <img src="/icons/phone.png" alt="title"/>
                        </div>
                      </div>
                      <div className="form-group">
                        <div className="col-xs-9">
                          <div className="row file-upload-button">
                            <div className="col-md-7 text-center document-upload" data-toggle="tooltip" data-original-title={this.state.documentError}>
                                <label>
                                  {
                                    this.state.labelUpload == "Upload your mortgage statement"
                                    ? <img src="/icons/upload.png" className="iconUpload"/>
                                    : null
                                  }
                                  <input name="potential_user[mortgage_statement]" id="uploadFile" type="file" onChange={this.handleFileChange}/>
                                  <span className="fileName">{this.state.labelUpload}</span>
                                </label>
                            </div>
                            <div className="col-md-5 text-center">
                              <p>{"Don't have a soft copy? No worries, you can take picture and email it to rate-alert@mortgageclub.co"}</p>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div className="form-group send-as">
                        <div className="col-sm-5">
                          <h5 className="text-left" data-toggle="tooltip" data-original-title={this.state.alertMethodError}>Send As</h5>
                            <div className="col-md-6 text-left">
                              <input type="checkbox" name="potential_user[send_as_email]" id="sendAsEmail"/>
                              <label className="customCheckbox blueCheckBox2" htmlFor="sendAsEmail">Email</label>
                            </div>
                            <div className="col-md-6 text-left">
                              <input type="checkbox" name="potential_user[send_as_text_message]" id="sendAsText"/>
                              <label className="customCheckbox blueCheckBox2" htmlFor="sendAsText">Text message</label>
                            </div>
                        </div>
                      </div>
                      <div className="row">
                        <div className="col-xs-5">
                          <button className="btn theBtn submit-btn text-uppercase" onClick={this.handleSubmit}>SET ALERT</button>
                        </div>
                      </div>
                    </form>
                  </div>
                  <div className="col-md-7 col-md-offset-3 mbl">
                    <p>(Please note: The use of information collected shall be limited to the purpose of monitoring your mortgage rates. We do not sell or share your information with anyone else).</p>
                  </div>
                </div>
            }
          </div>
        </div>
      </div>
    );
  }
});

module.exports = RateAlert;