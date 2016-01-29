var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");
var TextFormatMixin = require("mixins/TextFormatMixin");

var PotentialUserForm = React.createClass({
  mixins: [TextFormatMixin],
  getInitialState: function() {
    return {
      phoneNumber: null
    }
  },

  handleFileChange: function(event){
  },

  handleSubmit: function(event){
    event.preventDefault();

    var form = document.forms.namedItem("fileinfo");
    var formData = new FormData(form);

    $.ajax({
      url: "/potential_users",
      data: formData,
      method: "POST",
      enctype: "multipart/form-data",
      dataType: "json",
      success: function(response) {

      },
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(error){

      }
    });
  },

  changePhoneNumber: function(event) {
    var phoneNumber = this.formatPhoneNumber(event.target.value);
    this.setState({phoneNumber: phoneNumber});
  },

  render: function() {
    var uploadUrl = '/potential_users/mortage_statement/upload';

    return (
      <div className="login-form">
        <div className="loginPart signupPart content">
          <div className="container">
            <div className="col-md-4 col-md-offset-4">
              <form className="potential-users form-horizontal text-center" action="/potential_users" type="json" enctype="multipart/form-data" method="post" name="fileinfo">
                <h2 className="text-capitalize">upload your</h2>
                <h2 className="text-capitalize">mortgage statement</h2>
                <div className="form-group">
                  <div className="col-xs-12">
                    <div className="row file-upload-button">
                      <div className="col-md-9">
                          <label>
                            <img src="/icons/upload.png" className="iconUpload"/>
                            <input name="potential_user[mortgage_statement]" type="file" onChange={this.handleFileChange}/>
                            <span>Upload</span>
                          </label>
                      </div>
                      <div className="col-md-3">
                        <a className="icon-trash">
                          <img src="/icons/trash.png" />
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-sm-12 email-address">
                    <h5 className="text-left">Email Address</h5>
                    <input type="email" className="form-control" name="potential_user[email]"
                      id="email"/>
                    <img src="/icons/mail.png" alt="title"/>
                  </div>
                </div>
                <div className="form-group">
                  <div className="col-sm-12 last-name">
                    <h5 className="text-left">Phone Number (if applicable)</h5>
                    <input type="text" className="form-control" name="potential_user[phone_number]" id="last_name" value={this.state.phoneNumber} onChange={this.changePhoneNumber}/>
                    <img src="/icons/phone.png" alt="title"/>
                  </div>
                </div>
                <div className="row">
                  <div className="col-xs-12">
                    <button className="btn theBtn submit-btn text-uppercase" onClick={this.handleSubmit}>Submit</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = PotentialUserForm;