var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var ModalLink = require('components/ModalLink');
var TextEditor = require('components/TextEditor');

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
    if(this.props.PotentialRateDropUser) {
      return {
        email: this.props.PotentialRateDropUser.email,
        phone_number: this.props.PotentialRateDropUser.phone_number,
      };
    }
  },

  onChange: function(event) {
    this.setState(event)
  },

  onContentChange: function(content){
    this.setState({answer: content});
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-potential-user')[0]);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          email: response.potential_user.email,
          phone_number: response.potential_user.phone_number,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.potential_users){
          this.props.onReloadTable(response.potential_users);
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
    if(this.props.PotentialRateDropUser) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/potential_user_managements';
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
        <form className="form-horizontal form-loan-potential-user">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Email"
                keyName="email"
                name="potential_user[email]"
                value={this.state.email}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-4">
               <TextField
                label="Phone Number"
                keyName="phone_number"
                name="potential_user[phone_number]"
                value={this.state.phone_number}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>
          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.PotentialRateDropUser ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removePotentialRateDropUser" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removePotentialRateDropUser"
          title="Confirmation"
          body="Are you sure to remove this potential user?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
