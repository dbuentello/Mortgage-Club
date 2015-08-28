var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var UploadField = require('components/form/UploadField');

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
        phoneNumber: this.props.Member.phone_number,
        skypeHandle: this.props.Member.skype_handle
      };
    }else {
      return {};
    }
  },

  onChange: function(event) {
    this.setState(event)
  },

  onClick: function(event) {
    event.preventDefault();
    this.setState({saving: true});
    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: $('.form-loan-member').serialize(),
      success: function(response) {
        this.setState(
          {
            email: response.loan_member.user.email,
            first_name: response.loan_member.first_name,
            last_name: response.loan_member.last_name,
            phone_number: response.loan_member.phone_number,
            skype_handle: response.loan_member.skype_handle,
            saving: false
          }
        );
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.loan_members){
          this.props.onReloadTable(response.loan_members);
        }
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.message };
        this.showFlashes(flash);
      }.bind(this)
    });
  },

  render: function() {
    return (
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
              label="Phone number"
              keyName="phoneNumber"
              name="loan_member[phone_number]"
              value={this.state.phoneNumber}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-sm-4">
            <TextField
              label="Skype"
              keyName="skypeHandle"
              name="loan_member[skype_handle]"
              value={this.state.skypeHandle}
              editable={true}
              onChange={this.onChange}/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-sm-10">
            <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
          </div>
        </div>
      </form>
    )
  }
});

module.exports = Form;
