var React = require('react/addons');
var _ = require('lodash');


var ValidationField = React.createClass({
    render: function() {
      if(this.props.activateRequiredField === true)
      {
        if(this.props.value === null || this.props.value === "" || this.props.value === undefined || this.props.value === "javascript:void(0)"){
          if($("#" + this.props.id).attr("aria-describedby") === undefined){
            $("#" + this.props.id).tooltip({
              title: this.props.title,
              placement: "bottom",
              trigger: "manual"
            }).tooltip('show');
          }
        }
        else{
          $("#" + this.props.id).tooltip('destroy');
        }
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
