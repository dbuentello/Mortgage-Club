var _ = require('lodash');
var React = require('react/addons');

var moment = require('moment');

var RecentLoanActivities = React.createClass({
  render: function() {
    var activities = this.props.LoanActivityList;

    return (
      <div>
          {
            _.map(activities, function(activity, index) {
              if(index + 1 == activities.length){
                return (
                  <div>
                    <p className="side-item" key={activity.id}>
                      {activity.name}
                      <br/>
                      <span className="activity-status">{activity.pretty_activity_status} by {activity.pretty_loan_member_name} {moment(activity.updated_at).fromNow()}</span>
                    </p>
                  </div>
                )
              }
              return (
                <div>
                  <p className="side-item" key={activity.id}>
                    {activity.name}
                    <br/>
                    <span className="activity-status">{activity.pretty_activity_status} by {activity.pretty_loan_member_name} {moment(activity.updated_at).fromNow()}</span>
                  </p>
                  <hr/>
                </div>
              )
            })
          }
      </div>
    )
  }
});

module.exports = RecentLoanActivities;

