var _ = require('lodash');
var React = require('react/addons');

var ActivitesInfo = React.createClass({
  componentDidMount: function() {
  },

  render: function() {
    var loan_activity = this.props.loan_activity;
    // console.log(loan_activity);
    // console.log(is_valid);

    return (
      <tr>
        <td>{loan_activity.pretty_activity_type}</td>
        <td>{loan_activity.name}</td>
        <td>{loan_activity.pretty_activity_status}</td>
        <td>{loan_activity.pretty_duration}</td>
        <td>{loan_activity.pretty_user_visible}</td>
      </tr>
    )
  }

});

module.exports = ActivitesInfo;