var _ = require('lodash');
var React = require('react/addons');

var moment = require('moment');
require("moment-duration-format");

var FlashHandler = require('mixins/FlashHandler');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var ActivityTypes = [];

var TypeNameMapping = {};

var ActivityTab = React.createClass({
  mixins: [FlashHandler, ObjectHelperMixin, TextFormatMixin],
  
  getInitialState: function() {
    _.each(this.props.activity_types, function(activity_type){
      ActivityTypes.push({
        "value": activity_type.id,
        "label": activity_type.label
      });
      TypeNameMapping[activity_type.id] = activity_type.type_name_mapping;
    });

    return {
      current_type_id: _.keys(TypeNameMapping)[0],
      current_name: "Verify borrower's income",
      current_status: 0,
      acctivity_name_list: _.values(TypeNameMapping)[0],
      shown_to_user: true,
      loan_activities: this.props.loan_activities
    };
  },

  componentDidMount: function() {
    this.disableButton(this.props.first_activity.activity_status);
    	$('.bootstrap-select').selectpicker();

  },

  onTypeChange: function(event) {
    this.state.current_type_id = event.target.value;
    var firstNameOfCurrentType = TypeNameMapping[this.state.current_type_id][0];

    this.setState({
      current_name: firstNameOfCurrentType,
      acctivity_name_list: TypeNameMapping[this.state.current_type_id]
    });

    this.setNewActivityStatus(this.state.current_type_id, firstNameOfCurrentType);
  },

  onNameChange: function(event) {
    this.state.current_name = event.target.value;
    this.setNewActivityStatus(this.state.current_type_id, this.state.current_name);
  },

  onShownClick: function(event) {
    this.setState({
      shown_to_user: !this.state.shown_to_user
    })
  },

  onActionClick: function(event) {
    var previous_status = this.state.current_status;
    this.state.current_status = event.target.value;

    // immediately change the button status
    this.disableButton(this.state.current_status);

    $.ajax({
      url: '/loan_members/loan_activities',
      method: 'POST',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type_id: this.state.current_type_id,
          activity_status: this.state.current_status,
          name: this.state.current_name,
          user_visible: this.state.shown_to_user,
          loan_id: this.props.loan.id
        }
      },
      success: function(response) {
        var flash = { "alert-success": "Updated successfully!" };
        this.showFlashes(flash);

        this.setState({
          loan_activities: response.activities
        });
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.error };
        this.showFlashes(flash);

        this.disableButton(previous_status);
      }.bind(this)
    });
  },

  render: function() {
    var current_user = this.props.currentUser;
    var loan = this.props.loan;

    return (
      <div className="panel panel-flat">
        <div className="panel-body">
          <div className="row" style={{"margin-bottom": "10px"}}>

            <div className="col-xs-4">
              <select className="form-control bootstrap-select" onChange={this.onTypeChange}>
                {
                  _.map(ActivityTypes, function(type) {
                    return (
                      <option value={type.value} key={type.value}>{type.label}</option>
                    )
                  })
                }
              </select>
            </div>
            <div className="col-xs-4">


              <select className="form-control bootstrap-select" onChange={this.onNameChange}>
                {
                  _.map(this.state.acctivity_name_list, function(name) {
                    return (
                      <option value={name} key={name}>{name}</option>
                    )
                  })
                }
              </select>
            </div>
            <div className="col-xs-2">
              <label className="checkbox-inline">
                <div className="checker border-primary text-primary">

                      <span className={ this.state.shown_to_user
                        ? "checked" : "" }>



                    {this.state.shown_to_user}{this.state.shown_to_user}
                    <input type="checkbox" className="styled" defaultChecked={this.state.shown_to_user} onClick={this.onShownClick}/>

                  </span>
                </div>
                      Shown to user?
              </label>

            </div>
          </div>

          <div className="row" style={{"margin-bottom": "10px"}}>
            <div className="col-xs-1">
              <button className="btn btn-primary" value="0" onClick={this.onActionClick} disabled={this.state.disabledStartButton} style={{"width": "100%"}}>START</button>
            </div>
            <div className="col-xs-1">
              <button className="btn btn-success" value="1" onClick={this.onActionClick} disabled={this.state.disabledDoneButton} style={{"width": "100%"}}>DONE</button>
            </div>
            <div className="col-xs-1">
              <button className="btn btn-danger" value="2" onClick={this.onActionClick} disabled={this.state.disabledPauseButton}>PAUSE</button>
            </div>
          </div>
        </div>

        <div className="table-responsive" style={{borderTop: "1px solid #ddd"}} id="activities-table">
          <table className="table">
            <thead>
              <tr>
                <th style={{'width': '15%'}}>Activity Type</th>
                <th style={{'width': '21%'}}>Name</th>
                <th style={{'width': '7%'}}>Status</th>
                <th style={{'width': '8%'}}>Start Date</th>
                <th style={{'width': '8%'}}>End Date</th>
                <th style={{'width': '14%'}}>Duration</th>
                <th style={{'width': '15%'}}>Shown to user?</th>
                <th style={{'width': '12%'}}>By</th>
              </tr>
            </thead>
            <tbody>
              {
                _.map(this.state.loan_activities, function(loan_activity) {
                  console.log(loan_activity);
                  return (
                    <tr key={loan_activity.id}>
                      <td>{loan_activity.pretty_activity_type}</td>
                      <td>{loan_activity.name}</td>
                      {
                        loan_activity.pretty_activity_status.toUpperCase() == "STARTED"
                        ? <td><span className="label label-flat border-primary text-primary-600">STARTED</span></td>
                        : null
                      }
                      {
                        loan_activity.pretty_activity_status.toUpperCase() == "DONE"
                        ? <td><span className="label label-flat border-success text-success-600">DONE</span></td>
                        : null
                      }
                      {
                        loan_activity.pretty_activity_status.toUpperCase() == "PAUSED"
                        ? <td><span className="label label-flat border-danger text-danger-600">PAUSED</span></td>
                        : null
                      }
                      <td>{this.isoToUsDate(loan_activity.start_date)}</td>
                      <td>{this.isoToUsDate(loan_activity.end_date)}</td>
                      <td>{moment.duration(loan_activity.duration, "seconds").format("d [days ] h:mm:ss", { trim: false })}</td>
                      {
                        loan_activity.pretty_user_visible == "true"
                        ? <td style={{"text-align": "center"}}><span className="text-success-600"><i className="icon-checkmark3"></i></span></td>
                        : <td style={{"text-align": "center"}}><span className="text-danger-600"><i className="icon-cross2"></i></span></td>
                      }
                      <td>{loan_activity.pretty_loan_member_name}</td>
                    </tr>
                  )
                },this)
              }
            </tbody>
          </table>
        </div>
      </div>
    )
  },

  setNewActivityStatus: function(activity_type_id, activity_name) {
    $.ajax({
      url: '/loan_members/loan_activities/get_activities_by_conditions',
      method: 'GET',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type_id: activity_type_id,
          name: activity_name,
          loan_id: this.props.loan.id
        }
      },
      success: function(activities) {
        _.map(activities, function(activity) {
          if (activity[0]) {
            this.disableButton(activity[0].activity_status);
          }
          else {
            this.disableButton();
          }
        }, this);
      },
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  disableButton: function(button_value) {
    switch(button_value) {
      case '0':
      case 'start':
        this.setState({disabledStartButton: true});
        this.setState({disabledDoneButton: false});
        this.setState({disabledPauseButton: false});
        break;
      case '1':
      case 'done':
        this.setState({disabledDoneButton: true});
        this.setState({disabledStartButton: false});
        this.setState({disabledPauseButton: true});
        break;
      case '2':
      case 'pause':
        this.setState({disabledPauseButton: true});
        this.setState({disabledStartButton: false});
        this.setState({disabledDoneButton: false});
        break;
      default:
        this.setState({disabledStartButton: false});
        this.setState({disabledDoneButton: true});
        this.setState({disabledPauseButton: true});
    }
  },
});

module.exports = ActivityTab;
