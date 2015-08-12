var _ = require('lodash');
var React = require('react/addons');

var moment = require('moment');

var RecentLoanActivities = React.createClass({

  componentDidMount: function() {
    // console.dir(this.props.LoanActivityList);
  },

  render: function() {
    var activities = this.props.LoanActivityList;

    return (
      <div>
        <ul className="list-group">
          {
            _.map(activities, function(activity) {
              return (
                <li className="list-group-item">
                  {activity.name}
                  <br/>
                  <i><b>{activity.pretty_activity_status}</b> by <b>{activity.pretty_loan_member_name}</b> {moment(activity.updated_at).fromNow()}</i>
                </li>
              )
            })
          }
        </ul>
      </div>
    )
  }
});

module.exports = RecentLoanActivities;

