var React = require('react/addons');
var _ = require('lodash');


var ValidationField = React.createClass({
    render: function() {
      if(this.props.activateRequiredField === true)
      {
        $("#" + this.props.id).tooltip('show');
      }
      else{
        $("#" + this.props.id).tooltip('destroy');
      }
      return (
          <div></div>
      );
    }
});

module.exports = ValidationField;
