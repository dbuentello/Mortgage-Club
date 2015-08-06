var _ = require('lodash');
var React = require('react/addons');

var SelectBoxActivityType = React.createClass({

  propTypes: {
    onChange: React.PropTypes.func.isRequired,
    acctivityTypeList: React.PropTypes.array
  },

  render: function() {
    return (
      <select className="form-control" onChange={this.props.onChange}>
        {
          _.map(this.props.acctivityTypeList, function(type) {
            return (
              <option value={type.value}>{type.label}</option>
            )
          })
        }
      </select>
    )
  }
});

module.exports = SelectBoxActivityType;