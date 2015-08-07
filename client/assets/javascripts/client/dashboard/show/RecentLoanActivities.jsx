var _ = require('lodash');
var React = require('react/addons');

var RecentLoanActivities = React.createClass({

  componentDidMount: function() {
    console.dir(this.props.LoanActivityList);
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
                  <span className="badge">{activity.activity_status}</span>
                  {activity.name}
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

