// TODO: Unused

var _ = require('lodash');
var React = require("react/addons");
var FlashHandler = require("mixins/FlashHandler");

var SettingsTab = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    var user = this.props.bootstrapData.user;
    return {
      avatarUrl: user.avatar_url || "no-avatar.jpg",
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
    }
  },

  onChange: function(type, event){
    var value = event.target.value;
    switch(type){
      case "email":
        this.setState({email: value, emailError: null});
        break;
      case "first_name":
        this.setState({first_name: value, firstNameError: null});
        break;
      case "last_name":
        this.setState({last_name: value, lastNameError: null});
        break;
      case "password":
        this.setState({passwordError: null});
        break;
      case "password_confirmation":
        this.setState({passwordConfirmationError: null});
        break;
      case "current_password":
        this.setState({currentPasswordError: null});
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
          firstNameError: null,
          lastNameError: null,
          emailError: null,
          passwordError: null,
          passwordConfirmationError: null,
          currentPasswordError: null,
          saving: false
        })
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        this.setState({
          firstNameError: response.responseJSON.first_name,
          lastNameError: response.responseJSON.last_name,
          emailError: response.responseJSON.email,
          passwordError: response.responseJSON.password,
          passwordConfirmationError: response.responseJSON.password_confirmation,
          currentPasswordError: response.responseJSON.current_password,
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
    this.checkToShowTooltip(this.state.firstNameError, "#first_name", ".first-name");
    this.checkToShowTooltip(this.state.lastNameError, "#last_name", ".last-name");
    this.checkToShowTooltip(this.state.emailError, "#email", ".email-address");
    this.checkToShowTooltip(this.state.passwordError, "#password", ".password");
    this.checkToShowTooltip(this.state.passwordConfirmationError, "#password_confirmation", ".password-confirmation");
    this.checkToShowTooltip(this.state.currentPasswordError, "#current_password", ".current-password");
  },

  checkToShowTooltip: function(stateError, selector, viewport){
    if(stateError !== undefined && stateError !== "" && stateError !== null){
      if($(selector).attr("aria-describedby") === undefined){
        $(selector).tooltip({
          placement: "left",
          trigger: "manual",
          viewport: viewport,
          title: stateError
        }).tooltip("show");
      }
    }else{
      $(selector).tooltip("destroy");
    }
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
      <div className="content loans-part">
        <div className="container borrower-dashboard">
          <div className='tabs'>
            <div className="tab-content">
              <div>
                <div className="col-md-4 col-md-offset-4">
                  <form className="form-settings form-horizontal text-center" action="/auth/register" method="PUT">
                    <h4 className="text-capitalize text-left typeBold">account settings</h4>
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
                      <div className="col-sm-12 first-name">
                        <h5 className="text-capitalize text-left">first name</h5>
                        <input type="text" className="form-control" name="user[first_name]"
                          id="first_name" value={this.state.first_name}
                          onChange={_.bind(this.onChange, null, "first_name")}/>
                        <img src="/icons/name.png" alt="title"/>
                      </div>
                    </div>
                    <div className="form-group">
                      <div className="col-sm-12 last-name">
                        <h5 className="text-capitalize text-left">last name</h5>
                        <input type="text" className="form-control" name="user[last_name]"
                          id="last_name" value={this.state.last_name} onChange={_.bind(this.onChange, null, "last_name")}/>
                        <img src="/icons/name.png" alt="title"/>
                      </div>
                    </div>
                    <div className="form-group">
                      <div className="col-sm-12 email-address">
                        <h5 className="text-capitalize text-left">email address</h5>
                        <input type="hidden" name="user[id]" id="user_id" value={this.props.bootstrapData.user.id}/>
                        <input type="email" className="form-control" name="user[email]"
                          id="email" value={this.state.email} onChange={_.bind(this.onChange, null, "email")}/>
                        <img src="/icons/mail.png" alt="title"/>
                      </div>
                    </div>
                    <div className="form-group">
                      <div className="col-sm-12 password">
                        <h5 className="text-capitalize text-left">password</h5>
                        <input type="password" className="form-control" name="user[password]"
                          id="password" onChange={_.bind(this.onChange, null, "password")}/>
                        <img src="/icons/password.png" alt="title"/>
                      </div>
                    </div>
                    <div className="form-group">
                      <div className="col-sm-12 password-confirmation">
                        <h5 className="text-capitalize text-left">password confirmation</h5>
                        <input type="password" className="form-control" name="user[password_confirmation]"
                          id="password_confirmation" onChange={_.bind(this.onChange, null, "password_confirmation")}/>
                        <img src="/icons/passwordconfirm.png" alt="title"/>
                      </div>
                    </div>
                    <div className="form-group">
                      <div className="col-sm-12 current-password">
                        <h5 className="text-capitalize text-left">current password</h5>
                        <input type="password" className="form-control" name="user[current_password]"
                          id="current_password" onChange={_.bind(this.onChange, null, "current_password")}/>
                        <img src="/icons/password.png" alt="title"/>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = SettingsTab;
