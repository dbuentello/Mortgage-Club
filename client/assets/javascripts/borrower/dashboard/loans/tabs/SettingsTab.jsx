var _ = require('lodash');
var React = require("react/addons");
var FlashHandler = require("mixins/FlashHandler");

var SettingsTab = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      avatarUrl: this.props.user.avatar_url || "no-avatar.jpg",
      email: this.props.user.email,
      first_name: this.props.user.first_name,
      last_name: this.props.user.last_name,
    }
  },

  onChange: function(type, event){
    var value = event.target.value;

    switch(type){
      case "email":
        this.setState({email: value});
        break;
      case "first_name":
        this.setState({first_name: value});
        break;
      case "last_name":
        this.setState({last_name: value});
        break;
      default:
        break;
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
        this.setState({
          avatarUrl: response.user.avatar_url,
          email: response.user.email,
          first_name: response.user.first_name,
          last_name: response.user.last_name,
          saving: false
        })
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        this.setState({
          // firstNameError: response.responseJSON.first_name,
          // lastNameError: response.responseJSON.last_name,
          // emailError: response.responseJSON.email,
          // passwordError: response.responseJSON.password,
          passwordConfirmationError: response.responseJSON.password_confirmation,
          // currentPasswordError: response.responseJSON.current_password,
          saving: false
        })
      }
    });
    event.preventDefault();
  },

  showPreviewImage: function(event){
    if (event.target.files && event.target.files[0]){
      this.setState({avatarUrl: URL.createObjectURL(event.target.files[0])});
    }
  },

  componentDidUpdate: function() {
    $("[data-toggle='tooltip']").tooltip({
      placement: "left",
      trigger: "manual"
    }).tooltip("show");
  },

  removeAllTooltip: function() {
    $("#first_name").tooltip("destroy");
    $("#last_name").tooltip("destroy");
    $("#email").tooltip("destroy");
    $("#password").tooltip("destroy");
    $("#password_confirmation").tooltip("destroy");
    $("#current_password").tooltip("destroy");
  },

  render: function() {
    return (
      <div>
        <div className="col-md-4 col-md-offset-4">
          <form className="form-settings form-horizontal text-center" action="/auth/register" method="PUT">
            <h3 className="text-capitalize text-left">account settings</h3>
            <div className="form-group">
              <div className="col-xs-6">
                <img className="avatar" src={this.state.avatarUrl} id="currentAvatar"/>
              </div>
              <div className="col-xs-6">
                <div className="row">
                  <div className="col-xs-12">
                    <label className="btn upload-btn fileUpload">
                      <input name="user[avatar]" type='file' accept="image/*" onChange={this.showPreviewImage}/>
                      Upload Photo
                    </label>
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
                <h5 className="text-capitalize text-left">first name</h5>
                <input type="text" className="form-control" name="user[first_name]"
                  id="first_name" value={this.state.first_name}
                  onChange={_.bind(this.onChange, null, "first_name")}
                  data-toggle="tooltip" data-original-title={this.state.firstNameError}/>
                <img src="/icons/name.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">last name</h5>
                <input type="text" className="form-control" name="user[last_name]"
                  id="last_name" value={this.state.last_name} onChange={_.bind(this.onChange, null, "last_name")}
                  data-toggle="tooltip" data-original-title={this.state.lastNameError}/>
                <img src="/icons/name.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">email address</h5>
                <input type="hidden" name="user[id]" id="user_id" value={this.props.user.id}/>
                <input type="email" className="form-control" name="user[email]"
                  id="email" value={this.state.email} onChange={_.bind(this.onChange, null, "email")}
                  data-toggle="tooltip" data-original-title={this.state.emailError}/>
                <img src="/icons/mail.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">password</h5>
                <input type="password" className="form-control" name="user[password]"
                  id="password" data-toggle="tooltip" data-original-title={this.state.passwordError}/>
                <img src="/icons/password.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">password confirmation</h5>
                <input type="password" className="form-control" name="user[password_confirmation]"
                  id="password_confirmation" data-toggle="tooltip" data-original-title={this.state.passwordConfirmationError}/>
                <img src="/icons/passwordconfirm.png" alt="title"/>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">current password</h5>
                <input type="password" className="form-control" name="user[current_password]"
                  id="current_password" data-toggle="tooltip" data-original-title={this.state.currentPasswordError}/>
                <img src="/icons/password.png" alt="title"/>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }
});

module.exports = SettingsTab;