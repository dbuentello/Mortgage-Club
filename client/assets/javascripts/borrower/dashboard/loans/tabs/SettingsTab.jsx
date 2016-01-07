var React = require("react/addons");
var FlashHandler = require("mixins/FlashHandler");
var UploadPhoto = require("components/form/UploadPhoto");

var SettingsTab = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      avatarUrl: this.props.user.avatar_url || "no-avatar.jpg",
      email: this.props.user.email
    }
  },

  handleUpdate: function(event){
    this.setState({saving: true});
    var formData = new FormData($(".form-settings")[0]);
    $.ajax({
      url: "/auth/register",
      data: formData,
      method: "PUT",
      enctype: "multipart/form-data",
      dataType: "json",
      context: this,
      success: function(response) {
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        this.setState({
          avatarUrl: response.user.avatar_url,
          email: response.user.email,
          saving: false
        })
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }
    });
    event.preventDefault();
  },

  render: function() {
    return (
      <div>
        <div className="col-md-4 col-md-offset-4">
          <form className="form-settings form-horizontal text-center" action="/auth/register" method="PUT">
            <h3 className="text-capitalize text-left">account settings</h3>
            <div className="form-group">
              <div className="col-xs-6">
                <img className="avatar" src={this.state.avatarUrl}/>
              </div>
              <div className="col-xs-6">
                <div className="row">
                  <div className="col-xs-12">
                    <a className="btn upload-btn fileUpload">
                      <UploadPhoto
                        label="Upload Photo"
                        keyName="avatar"
                        name="user[avatar]"/>
                    </a>
                  </div>
                </div>
                <div className="row">
                  <div className="col-xs-12">
                    <button className="btn update-btn" onClick={this.handleUpdate}>{this.state.saving ?  "Updating" : "Update"}</button>
                  </div>
                </div>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">email address</h5>
                <input type="hidden" name="user[id]" id="user_id" value={this.props.user.id}/>
                <input type="email" className="form-control" name="user[email]" id="email" value={this.state.email}/>
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">password</h5>
                <input type="password" className="form-control" name="user[password]" id="password"/>
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">password confirmation</h5>
                <input type="password" className="form-control" name="user[password_confirmation]" id="password_confirmation"/>
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">current password</h5>
                <input type="password" className="form-control" name="user[current_password]" id="current_password"/>
                <img src="/icons/pen.png" alt="title"/>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }
});

module.exports = SettingsTab;