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
        label: this.props.ActivityType.label,
        type_name_mapping: this.props.ActivityType.type_name_mapping,
        type_name: "",
        order_number: this.props.ActivityType.order_number
      };
    }else{
      return {
        label: "",
        type_name_mapping: [],
        type_name: "",
        order_number: ""
      }
    }
  },

  onChange: function(event) {
    this.setState(event);
  },

  onClick: function(event) {
    this.setState({saving: true});
    event.preventDefault();
    var formData = new FormData($('.form-loan-acitivity-type')[0]);
    _.each(this.state.type_name_mapping, function(type_name){
      formData.append("activity_type[type_name_mapping][]", type_name);
    });

    $.ajax({
      url: this.props.Url,
      method: this.props.Method,
      enctype: 'multipart/form-data',
      data: formData,
      success: function(response) {
        this.setState({
          label: response.activity_type.label,
          type_name_mapping: response.activity_type.type_name_mapping,
          order_number: response.activity_type.order_number,
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

  addTypeNameMapping: function(event){
    var typeNameMapping = this.state.type_name_mapping.slice();
    typeNameMapping.push(this.state.type_name);

    this.setState({
      type_name_mapping: typeNameMapping
    });
  },

  removeTypeNameMapping: function(index){
    var typeNameMapping = this.state.type_name_mapping;
    typeNameMapping.splice(index, 1);

    this.setState({
      type_name_mapping: typeNameMapping
    });
  },

  render: function() {
    return (
      <div>
        <form className="form-horizontal form-loan-acitivity-type">
          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Activity Type"
                keyName="label"
                name="activity_type[label]"
                value={this.state.label}
                editable={true}
                onChange={this.onChange}/>
            </div>
            <div className="col-sm-4">
              <TextField
                label="Order Number"
                keyName="order_number"
                name="activity_type[order_number]"
                value={this.state.order_number}
                editable={true}
                onChange={this.onChange}/>
            </div>
          </div>

          <div className="form-group">
            <div className="col-sm-4">
              <TextField
                label="Activity Name"
                keyName="type_name"
                value={this.state.type_name}
                editable={true}
                onChange={this.onChange}/>
            </div>
            <div className="col-sm-2">
              <a className="btn btn-default" id="addTypeNameMapping" onClick={this.addTypeNameMapping} role="button">+</a>
            </div>
          </div>
          <div className="form-group">
          <div className="col-sm-4">
            {
              _.map(this.state.type_name_mapping, function(type_name, index) {
                return (
                  <div className="row input-sm">
                    <div className="col-sm-8 pan">
                      {type_name}
                    </div>
                    <div className="col-sm-4">
                      <a className="btn btn-danger" id="removeTypeNameMapping" onClick={this.removeTypeNameMapping.bind(this, index)} role="button">x</a>
                    </div>
                  </div>
                )
              }, this)
            }
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
