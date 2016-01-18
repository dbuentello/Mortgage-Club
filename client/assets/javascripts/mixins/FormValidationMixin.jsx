var _ = require('lodash');
var valid = true;

var FormValidationMixin = {
  // fields = { borrower_fields.yearsInSchool.error: 2, borrower_fields.currentAddress.error: "Any where" }
  getStateOfInvalidFields: function(fields) {
    var state = {};
    _.each(fields, function(value, key) {
      if(this.elementIsEmpty(value)) {
        state[key] = true;
      }
    }, this);

    return state;
  },

  elementIsEmpty: function(obj) {
    if(obj == null) {
      return true;
    }

    if(typeof(obj) == "string") {
      if(obj.trim() == "") {
        return true;
      }
    }

    return false;
  },

  requiredFieldsHasEmptyElement: function(stateArray, outputFields) {
    var empty = false;
    var stateObj = {};
    for(var i = 0; i < stateArray.length; i++) {
      if (this.elementIsEmpty(stateArray[i]))
      {
        empty = true;
        stateObj[outputFields[i]] = true;
      }
    }
    return {state: stateObj, hasEmptyElement: empty};
  }
}

module.exports = FormValidationMixin;