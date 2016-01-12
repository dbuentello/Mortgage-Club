var _ = require('lodash');
var React = require('react/addons');
var FlashHandler = require('mixins/FlashHandler');
var TextField = require('components/form/TextField');
var ModalLink = require('components/ModalLink');

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
    if(this.props.ActivityType) {
      return {
        type: this.props.ActivityType.type,
        type_name_mapping: this.props.ActivityType.type_name_mapping,
      };
    }else{
      return {
        type: "",
        type_name_mapping: [""]
      }
    }
  },

  onChange: function(event) {
    this.setState(event)
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-acitivity-type')[0]);

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          type: response.activity_type.type,
          type_name_mapping: response.activity_type.type_name_mapping,
          saving: false
        });
        var flash = { "alert-success": response.message };
        this.showFlashes(flash);
        if(response.activity_types){
          this.props.onReloadTable(response.activity_types);
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
    if(this.props.ActivityType) {
      this.setState({removing: true});

      $.ajax({
        url: this.props.Url,
        method: 'DELETE',
        success: function(response) {
          var flash = { "alert-success": response.message };
          this.showFlashes(flash);
          location.href = '/loan_activity_type_managements';
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
        <form className="form-horizontal form-loan-acitivity-type">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Type"
                keyName="type"
                name="activity_type[type]"
                value={this.state.type}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>

          <div className="form-group">
            <div className="col-sm-10">
              <button className="btn btn-primary" onClick={this.onClick} disabled={this.state.saving}>{ this.state.saving ? 'Submitting' : 'Submit' }</button>
              &nbsp;
              { this.props.ActivityType ?
                <a className="btn btn-danger" data-toggle="modal" data-target="#removeActivityType" disabled={this.state.removing}>{ this.state.removing ? 'Removing' : 'Remove' }</a>
              : null
              }
            </div>
          </div>
        </form>
        <ModalLink
          id="removeActivityType"
          title="Confirmation"
          body="Are you sure to remove this activity type?"
          yesCallback={this.onRemove}
        />
      </div>
    )
  }
});

module.exports = Form;
