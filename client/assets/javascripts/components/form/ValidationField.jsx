var React = require('react/addons');
var _ = require('lodash');
var FormValidationMixin = require("mixins/FormValidationMixin");

var ValidationField = React.createClass({
  mixins: [FormValidationMixin],

  render: function() {
    if(this.props.activateRequiredField === true)
    {
      if(this.isEmptyValue() || this.isInvalidValue()){
        if(!this.hasTooltip()) {
          $("#" + this.props.id).tooltip({
            title: this.props.title,
            placement: "bottom",
            trigger: "manual"
          }).tooltip('show');
        }
      }
      else{
        $("#" + this.props.id).tooltip("destroy");
      }
    }
    else{
      $("#" + this.props.id).tooltip("destroy");
    }
    return (
      <div className="validation-field"></div>
    );
  },

  hasTooltip: function() {
    if($("#" + this.props.id).attr("aria-describedby") !== undefined) {
      return true;
    }
    return false;
  },

  isEmptyValue: function() {
    if(this.props.value === null || this.props.value === "" || this.props.value === undefined || this.props.value === "javascript:void(0)") {
      return true;
    }
    return false;
  },

  isInvalidValue: function() {
    var isInvalid = false;
    _.each(this.props.validationTypes, function(type) {
      switch(type) {
        case "currency":
          console.dir("aaa")
          if(!this.elementIsValidCurrency(this.props.value)) {
            console.dir("bbb")
            isInvalid = true;
          }
          break;
        case "agesOfDependents":
          if(!this.elementIsValidAgeofDependents(this.props.value)) {
            isInvalid = true;
          }
          break;
        case "ssn":
          if(!this.elementIsValidSSN(this.props.value)) {
            isInvalid = true;
          }
          break;
        case "email":
          if(!this.elementIsEmail(this.props.value)) {
            isInvalid = true;
          }
          break;
        case "integer":
          if(!this.elementIsInteger(this.props.value)) {
            isInvalid = true;
          }
          break;
        case "phoneNumber":
          if(!this.elementIsPhoneNumber(this.props.value)) {
            isInvalid = true;
          }
          break;
      }
    }, this);

    return isInvalid;
  }
});

module.exports = ValidationField;
