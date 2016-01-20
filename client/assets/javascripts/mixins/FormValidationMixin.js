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

  validCurrency: function(obj){
    var currencyPattern = /^((\$\d+)|(\$\d+(,\d{3})*(\.\d?)?))$/;

    return currencyPattern.test(obj);
  },

  elementNotReachMinLength: function(obj, minLength) {
    var result = false;
    if (!obj) { return true; }
    if (obj.length < minLength) {
      result = true;
    }
    return result;
  },

  elementIsValidAgeArray: function(obj, dependentCount) {
    var isValid = true;
    var ageArray = obj.split(",");
    if(ageArray.length !== dependentCount) {
      isValid = false;
    }
    for( var i = 0; i < ageArray.length; i++) {
      if(!this.elementIsInteger(ageArray[i])) {
        isValid = false;
        break;
      }
    }
    return isValid;
  },

  elementIsValidSSN: function(obj) {
    var ssnPattern = /^(\d{3})\-(\d{2})\-(\d{4})$/;
    return ssnPattern.test(obj);
  },

  elementMatchsPattern: function(obj, pattern) {
    if (!obj) { return false; }
    return pattern.test(obj);
  },

  elementIsEmail: function(obj) {
    var emailReg = /^[a-zA-Z]+[a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]+@([a-zA-Z]+[a-zA-Z0-9_\-]*\.){1,2}[a-zA-Z]{2,}$/;
    return emailReg.test(obj);
  },

  elementIsInteger: function(obj) {
    obj = obj.trim();
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

  elementLengthExceedsMaxlength: function(obj, maxLength) {
    var result = false;
    if (!obj) { return false }
    if (obj.length > maxLength) {
      result = true;
    }
    return result;
  },

  elementIsPhoneNumber: function(obj) {
    if(!obj){
      return false;
    }
    if(obj.length < 10){
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