var _ = require('lodash');
var React = require('react/addons');
var SelectBoxActivityName = require('./SelectBoxActivityName');
var SelectBoxActivityType = require('./SelectBoxActivityType');
var FlashHandler = require('mixins/FlashHandler');

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

var LoanActivity = React.createClass({
  mixins: [FlashHandler],

  getInitialState: function() {
    return {
      current_type: 0,
      current_name: "Verify borrower's income",
      current_status: 0,
      acctivityNameList: TypeNameMapping[0],
      shown_to_user: true,
      disabledStartButton: false,
      disabledDoneButton: true,
      disabledPauseButton: true
    };
  },

  getDefaultProps: function() {
  },

  componentDidMount: function() {
  },

  onTypeChange: function(event) {
    this.setState({
      current_type: event.target.value,
      current_name: TypeNameMapping[event.target.value][0],
      acctivityNameList: TypeNameMapping[event.target.value]
    });
    var activities = this.getNewActivityStatus(event.target.value);
  },

  getNewActivityStatus: function(activity_type) {
    $.ajax({
      url: '/loan_activities/get_activities_by_type',
      method: 'GET',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type: activity_type,
          loan_id: this.props.bootstrapData.loan.id,
        }
      },
      success: function(activities) {
        _.map(activities, function(activity) {
          if(activity[0]){
            this.disableButton(activity[0].activity_status);
          }
          else
          {
            this.disableButton();
          }
        }, this);
      },
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  onNameChange: function(event) {
    this.setState({
      current_name: event.target.value,
    });
  },

  onShownClick: function(event) {
    this.setState({
      shown_to_user: !this.state.shown_to_user
    })
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
        this.setState({disabledDoneButton: false});
        this.setState({disabledPauseButton: false});
    }
  },

  onActionClick: function(event) {
    this.state.current_status = event.target.value;
    $.ajax({
      url: '/loan_activities',
      method: 'POST',
      context: this,
      dataType: 'json',
      data: {
        loan_activity: {
          activity_type: this.state.current_type,
          activity_status: this.state.current_status,
          name: this.state.current_name,
          user_visible: this.state.shown_to_user,
          loan_id: this.props.bootstrapData.loan.id,
        }
      },
      success: function(response) {
        var flash = { "alert-success": "Updated successfully!" };
        this.showFlashes(flash);
        this.disableButton(this.state.current_status);
      }.bind(this),
      error: function(response, status, error) {
        alert(error);
      }
    });
  },

  render: function() {
    var current_user = this.props.bootstrapData.currentUser;
    var loan = this.props.bootstrapData.loan;

    return (
      <div className='content container'>
        <h2>Loan member dashboard</h2>
        <div className="row">
          <div className="col-xs-4 ptl">
            <SelectBoxActivityType acctivityTypeList={ActivityTypes} onChange={this.onTypeChange}></SelectBoxActivityType>
          </div>
          <div className="col-xs-4 ptl">
            <SelectBoxActivityName acctivityNameList={this.state.acctivityNameList}></SelectBoxActivityName>
          </div>
          <div className="col-xs-2 ptl">
            <div className="checkbox">
              <label>
                <input type="checkbox" checked={this.state.shown_to_user} onClick={this.onShownClick}/> Shown to user?
              </label>
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 ptl">
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
      </div>
    )
  }

});

module.exports = LoanActivity;