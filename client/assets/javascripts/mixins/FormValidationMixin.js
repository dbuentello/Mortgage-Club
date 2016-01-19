var _ = require('lodash');

module.exports = {
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

  elementIsEmail: function(obj) {
    var emailReg = /^[a-zA-Z]+[a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]+@([a-zA-Z]+[a-zA-Z0-9_\-]*\.){1,2}[a-zA-Z]{2,}$/;
    return emailReg.test(obj);
  },

  elementIsInteger: function(obj) {
    var digitReg = /^\d+$/;
    return digitReg.test(obj);
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
  elementIsPhoneNumber: function(obj) {
    if(!obj){
      return false;
    }
    if(obj.length<10){
      return false;
    }
    return (obj.match(/^\((\d{3})\)\s(\d{3})\-(\d{4})$/)!=null);
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