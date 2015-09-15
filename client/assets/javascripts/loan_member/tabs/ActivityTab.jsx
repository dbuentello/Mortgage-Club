var _ = require('lodash');
var React = require('react/addons');

var moment = require('moment');
require("moment-duration-format");

var FlashHandler = require('mixins/FlashHandler');
var ObjectHelperMixin = require('mixins/ObjectHelperMixin');
var TextFormatMixin = require('mixins/TextFormatMixin');

var ActivityTypes = [
  { "value": 0, "label": "Prior to Loan Submission" },
  { "value": 1, "label": "Prior to Loan Docs" },
  { "value": 2, "label": "Prior to Closing" },
  { "value": 3, "label": "Post Closing" }
];

var TypeNameMapping = {
  0: ["Verify borrower's income", "Verify borrower's down payment", "Verify borrower's rental properties", "Other"],
  1: ["Verify borrower's employment", "Ask borrower to submit additional documents"],
  2: ["Order preliminary title report", "Schedule notary appointment"],
  3: ["Review loan criteria per lender request"]
};

var ActivityTab = React.createClass({
  mixins: [FlashHandler, ObjectHelperMixin, TextFormatMixin],

  getInitialState: function() {
    return {
      current_type: '0',
      current_name: "Verify borrower's income",
      current_status: 0,
      acctivity_name_list: TypeNameMapping[0],
      shown_to_user: true,
      loan_submission_list: this.getValue(this.props.loan_activities, 'loan_submission'),
      loan_doc_list: this.getValue(this.props.loan_activities, 'loan_doc'),
      closing_list: this.getValue(this.props.loan_activities, 'closing'),
      post_closing_list: this.getValue(this.props.loan_activities, 'post_closing')
    };
  },

  componentDidMount: function() {
    this.disableButton(this.props.first_activity.activity_status);
  },

  onTypeChange: function(event) {
    this.state.current_type = event.target.value;
    var firstNameOfCurrentType = TypeNameMapping[this.state.current_type][0];

    this.setState({
      current_name: firstNameOfCurrentType,
      acctivity_name_list: TypeNameMapping[this.state.current_type]
    });

    this.setNewActivityStatus(this.state.current_type, firstNameOfCurrentType);
  },

  onNameChange: function(event) {
    this.state.current_name = event.target.value;
    this.setNewActivityStatus(this.state.current_type, this.state.current_name);
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
          activity_type: this.state.current_type,
          activity_status: this.state.current_status,
          name: this.state.current_name,
          user_visible: this.state.shown_to_user,
          loan_id: this.props.loan.id
        }
      },
      success: function(response) {
        var flash = { "alert-success": "Updated successfully!" };
        this.showFlashes(flash);

        this.reloadActivityList(this.state.current_type);
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
      <div className='content container boxBasic backgroundBasic'>
        <div className="row ptl">
          <div className="col-xs-4">
            <select className="form-control" onChange={this.onTypeChange}>
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
            <select className="form-control" onChange={this.onNameChange}>
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
            <div className="checkbox">
              <label>
                <input type="checkbox" defaultChecked={this.state.shown_to_user} onClick={this.onShownClick}/> Shown to user?
              </label>
            </div>
          </div>
        </div>

        <div className="row ptl">
          <div className="col-xs-12">
            <span>
              <button className="btn btn-primary mrs" value="0" onClick={this.onActionClick} disabled={this.state.disabledStartButton}>START</button>
            </span>
            <span>
              <button className="btn btn-primary mrs" value="1" onClick={this.onActionClick} disabled={this.state.disabledDoneButton}>DONE</button>
            </span>
            <span>
              <button className="btn btn-primary" value="2" onClick={this.onActionClick} disabled={this.state.disabledPauseButton}>PAUSE</button>
            </span>
          </div>
        </div>

        <div className="table-responsive">
          <table className="mtxl table table-bordered table-striped table-hover">
            <thead>
              <tr>
                <th style={{'width': '20%'}}>Activity Type</th>
                <th style={{'width': '30%'}}>Name</th>
                <th style={{'width': '8%'}}>Status</th>
                <th style={{'width': '10%'}}>Start Date</th>
                <th style={{'width': '10%'}}>End Date</th>
                <th style={{'width': '15%'}}>Duration</th>
                <th style={{'width': '12%'}}>Shown to user?</th>
                <th style={{'width': '15%'}}>By</th>
              </tr>
            </thead>
            <tbody>
              {
                _.map(this.state.loan_submission_list, function(loan_activity) {
                  return (
                    <tr key={loan_activity.id}>
                      <td>{loan_activity.pretty_activity_type}</td>
                      <td>{loan_activity.name}</td>
                      <td>{loan_activity.pretty_activity_status.toUpperCase()}</td>
                      <td>{this.isoToUsDate(loan_activity.start_date)}</td>
                      <td>{this.isoToUsDate(loan_activity.end_date)}</td>
                      <td>{moment.duration(loan_activity.duration, "seconds").format("d [days ] h:mm:ss", { trim: false })}</td>
                      <td>{loan_activity.pretty_user_visible}</td>
                      <td>{loan_activity.pretty_loan_member_name}</td>
                    </tr>
                  )
                },this)
              }

              {
                _.map(this.state.loan_doc_list, function(loan_activity) {
                  return (
                    <tr key={loan_activity.id}>
                      <td>{loan_activity.pretty_activity_type}</td>
                      <td>{loan_activity.name}</td>
                      <td>{loan_activity.pretty_activity_status.toUpperCase()}</td>
                      <td>{this.isoToUsDate(loan_activity.start_date)}</td>
                      <td>{this.isoToUsDate(loan_activity.end_date)}</td>
                      <td>{moment.duration(loan_activity.duration, "seconds").format("d [days ] h:mm:ss", { trim: false })}</td>
                      <td>{loan_activity.pretty_user_visible}</td>
                      <td>{loan_activity.pretty_loan_member_name}</td>
                    </tr>
                  )
                },this)
              }

              {
                _.map(this.state.closing_list, function(loan_activity) {
                  return (
                    <tr key={loan_activity.id}>
                      <td>{loan_activity.pretty_activity_type}</td>
                      <td>{loan_activity.name}</td>
                      <td>{loan_activity.pretty_activity_status.toUpperCase()}</td>
                      <td>{this.isoToUsDate(loan_activity.start_date)}</td>
                      <td>{this.isoToUsDate(loan_activity.end_date)}</td>
                      <td>{moment.duration(loan_activity.duration, "seconds").format("d [days ] h:mm:ss", { trim: false })}</td>
                      <td>{loan_activity.pretty_user_visible}</td>
                      <td>{loan_activity.pretty_loan_member_name}</td>
                    </tr>
                  )
                },this)
              }

              {
                _.map(this.state.post_closing_list, function(loan_activity) {
                  return (
                    <tr key={loan_activity.id}>
                      <td>{loan_activity.pretty_activity_type}</td>
                      <td>{loan_activity.name}</td>
                      <td>{loan_activity.pretty_activity_status.toUpperCase()}</td>
                      <td>{this.isoToUsDate(loan_activity.start_date)}</td>
                      <td>{this.isoToUsDate(loan_activity.end_date)}</td>
                      <td>{moment.duration(loan_activity.duration, "seconds").format("d [days ] h:mm:ss", { trim: false })}</td>
                      <td>{loan_activity.pretty_user_visible}</td>
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

  setNewActivityStatus: function(activity_type, activity_name) {
    $.ajax({
      url: '/loan_members/loan_activities/get_activities_by_conditions',
      method: 'GET',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type: activity_type,
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

  reloadActivityList: function(activity_type) {
    $.ajax({
      url: '/loan_members/loan_activities/get_activities_by_conditions',
      method: 'GET',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type: activity_type,
          loan_id: this.props.loan.id
        }
      },
      success: function(response) {
        switch(activity_type) {
          case '0':
            this.setState({ loan_submission_list: response.activities });
            break;
          case '1':
            this.setState({ loan_doc_list: response.activities });
            break;
          case '2':
            this.setState({ closing_list: response.activities });
            break;
          case '3':
            this.setState({ post_closing_list: response.activities });
            break;
        }
      }.bind(this),
      error: function(response, status, error) {
        var flash = { "alert-danger": response.responseJSON.error };
        this.showFlashes(flash);
      }
    });
  }
});

module.exports = ActivityTab;