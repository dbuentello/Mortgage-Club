var _ = require('lodash');
var React = require('react/addons');

var SelectBoxActivityName = React.createClass({
  propTypes: {
    acctivityNameList: React.PropTypes.array
  },

  render: function() {
    return (
      <select className="form-control">
        {
          _.map(this.props.acctivityNameList, function(name) {
            return (
              <option value={name}>{name}</option>
            )
          })
        }
      </select>
    )
  }
});

module.exports = SelectBoxActivityName;