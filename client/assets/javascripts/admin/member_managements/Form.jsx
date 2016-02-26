var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var UploadField = require('components/form/UploadField');
var ModalLink = require('components/ModalLink');
var BooleanRadio = require('components/form/BooleanRadio');

var Form = React.createClass({
  mixins: [FlashHandler],

  propTypes: {
    method: React.PropTypes.string,
    url: React.PropTypes.string,
    onReloadTable: React.PropTypes.func,
  },

  getDefaultProps: function() {
    return {
      method: 'POST',
      url: '',
      onReloadTable: null
    };
  },

  getInitialState: function() {
    if(this.props.Member) {
      return {
        email: this.props.Member.user ? this.props.Member.user.email : '',
        firstName: this.props.Member.user.first_name,
        lastName: this.props.Member.user.last_name,
        phoneNumber: this.props.Member.phone_number
      };
    }else {
      return {};
    }
  },

  onChange: function(event) {
    this.setState(event);
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-member')[0]);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState(
          {
            email: response.loan_member.user.email,
            first_name: response.loan_member.first_name,
            last_name: response.loan_member.last_name,
            phone_number: response.loan_member.phone_number,
            saving: false
          }
        );
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.loan_members){
          this.props.onReloadTable(response.loan_members);
        }
        this.setState({saving: false});
      }.bind(this),
      cache: false,
      contentType: false,
      processData: false,
      async: true,
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.message };
        this.showFlashes(flash);
        this.setState({saving: false});
      }.bind(this)
    });
  },

  onRemove: function(event) {
    if(this.props.Member) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_member_managements';
        }.bind(this),
        error: function(response, status, error) {
          var flash = { "alert-danger": response.responseJSON.message };
          this.showFlashes(flash);
        }.bind(this)
      });
    }
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-member">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Email"
                keyName="email"
                name="loan_member[email]"
                value={this.state.email}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <UploadField
                label="Avatar"
                keyName="avatar"
                name="loan_member[avatar]"/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="First Name"
                keyName="firstName"
                name="loan_member[first_name]"
                value={this.state.firstName}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Last Name"
                keyName="lastName"
                name="loan_member[last_name]"
                value={this.state.lastName}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Phone Number"
                keyName="phoneNumber"
                name="loan_member[phone_number]"
                value={this.state.phoneNumber}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          {
            this.props.Member
            ?
              null
            :
            <div className="form-group">
              <div className="col-sm-4">
                <TextField
                  label="Default Password"
                  keyName="password"
                  name="loan_member[password]"
                  value={this.state.password}
                  editable={true}
                  placeholder={"Minimum is 8 characters"}
                  onChange={this.onChange}/>
              </div>
            </div>
          }
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.Member ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeUser" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeUser"
          title="Confirmation"
          body="Are you sure to remove this user?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
