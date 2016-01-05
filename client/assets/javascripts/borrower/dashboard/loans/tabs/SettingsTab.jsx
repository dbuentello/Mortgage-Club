var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');

var SettingsTab = React.createClass({
  mixins: [FlashHandler],
  handleUpdate: function(){
    var form = $(this.refs.formEditUser.getDOMNode());
    $.ajax({
      url: "/auth/register",
      data: form.serialize(),
      method: 'PATCH',
      dataType: "json",
      context: this,
      success: function(response) {
        var flash = { "alert-success": "Update successfully, you may check your email to confirm change" };
        if (response.success == false) {
          flash = { "alert-danger": response.message };
        }
        this.showFlashes(flash);
      },
      error: function(response, status, error) {
        var flash = { "alert-danger": error };
        console.log(error);
        this.showFlashes(flash);
      }
    });
  },
  handleEmailChange: function(event) {
    this.setState({ user: {email: event.target.value}});
  },

  render: function() {
    return (
      <div>
        <div className="col-md-4 col-md-offset-4">
          <form ref="formEditUser" className="form-horizontal text-center" action="/auth/register" encType='application/json' method="POST">
            <h3 className="text-capitalize text-left">account settings</h3>
            <div className="form-group">
              <div className="col-xs-6"><div className="avatar"></div></div>
              <div className="row col-xs-6">
                <div className="col-xs-12">
                  <a href="#" className="btn upload-btn">Upload photo</a>
                </div>
                <div className="col-xs-12">
                  <button className="btn update-btn" onClick={this.handleUpdate}>Update</button>
                </div>
              </div>

            </div>
            <div className="form-group">
              <div className="col-sm-12">
                <h5 className="text-capitalize text-left">email address</h5>
                <input type="hidden" name="user[id]" id="user_id" value={this.props.user.id} />
                <input type="email" className="form-control" name="user[email]" id="email" />
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