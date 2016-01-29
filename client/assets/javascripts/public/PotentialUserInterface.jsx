var React = require("react/addons");
var Dropzone = require("components/form/NewDropzone");
var TextField = require("components/form/NewTextField");

module.exports = React.createClass({
  handleFileChange: function(event){
    console.log("File changed");

  },
  handleSubmit: function(event){
    event.preventDefault();
    console.log("You ha");
    var form = document.forms.namedItem("fileinfo");
    var formData = new FormData(form);
    console.log()
    console.log(formData);
    $.ajax({
      url: "/potential_users",
      data: formData,
      method: "POST",
      enctype: "multipart/form-data",
      dataType: "json",
      success: function(response) {
        console.log(response);
      },
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(error){
        console.log(error);
      }
    });

  },
  render: function() {
    var uploadUrl = '/potential_users/mortage_statement/upload';

    return (
      <div className="container">
        <div>
          <form className="potential-users form-horizontal text-center" action="/potential_users" type="json" enctype="multipart/form-data" method="post" name="fileinfo">
            <h3 className="text-capitalize text-left">Upload your mortgage statement</h3>
            <div className="form-group">
              <div className="col-xs-12">
                <div className="row file-upload-button">
                  <div className="col-md-9">
                    <img src="/icons/upload.png" className="iconUpload"/>
                      <label>
                        <input name="potential_user[mortgage_statement]" type="file" onChange={this.handleFileChange}/>
                        Upload
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
              <div className="col-sm-12 last-name">
                <h5 className="text-capitalize text-left">Phone number</h5>
                <input type="text" className="form-control" name="potential_user[phone_number]"
                  id="last_name" />
                <img src="/icons/name.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12 email-address">
                <h5 className="text-capitalize text-left">email address</h5>
                <input type="email" className="form-control" name="potential_user[email]"
                  id="email" />
                <img src="/icons/mail.png" alt="title"/>
              </div>
            </div>
            <div className="row">
              <div className="col-xs-12">
                <button className="btn update-btn" onClick={this.handleSubmit}>Submit</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }
});