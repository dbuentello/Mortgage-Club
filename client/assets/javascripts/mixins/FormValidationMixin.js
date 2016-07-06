/**
 * Check validation of fields
 */
var _ = require('lodash');

module.exports = {
  getStateOfInvalidFields: function(fields) {
    var state = {};
    _.each(fields, function(field, errorName) {
      _.each(field.validationTypes, function(type) {
        switch(type) {
          case "empty":
            if(this.elementIsEmpty(field.value)) {
              state[errorName] = true;
            }
            break;
          case "currency":
            if(!this.elementIsValidCurrency(field.value)) {
              state[errorName] = true;
            }
            break;
          case "agesOfDependents":
            if(!this.elementIsValidAgeofDependents(field.value)) {
              state[errorName] = true;
            }
            break;
          case "ssn":
            if(!this.elementIsValidSSN(field.value)) {
              state[errorName] = true;
            }
            break;
          case "email":
            if(!this.elementIsEmail(field.value)) {
              state[errorName] = true;
            }
            break;
          case "integer":
            if(!this.elementIsInteger(field.value)) {
              state[errorName] = true;
            }
            break;
          case "percent":
            if(!this.elementIsValidPercent(field.value)) {
              state[errorName] = true;
            }
            break;
          case "phoneNumber":
            if(!this.elementIsPhoneNumber(field.value)) {
              state[errorName] = true;
            }
            break;
          case "address":
            if(!this.elementIsAddress(field.value)){
              state[errorName] = true;
            }
        }
      }, this)
    }, this);

    return state;
  },
  elementIsValidPercent: function(obj){
    var percentPattern = /^((\$\d+)|(\$\d+(,\d{3})*(\.\d*)?))$/;

    return percentPattern.test(obj);
  },
  elementIsValidCurrency: function(obj){
    var currencyPattern = /^((\$\d+)|(\$\d+(,\d{3})*(\.\d*)?))$/;

    return currencyPattern.test(obj);
  },

  elementIsValidAgeofDependents: function(obj) {
    if(!obj) { return false; }
    var isValid = true;
    var ageArray = obj.split(",");
    for( var i = 0; i < ageArray.length; i++) {
      if(!this.elementIsInteger(ageArray[i].trim())) {
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

  elementIsEmail: function(obj) {
    //console.log("check email in FormValidationMixin");
    if(!obj) { return false; }
    var emailReg =/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    return emailReg.test(obj);
  },

  elementIsValidNotFutureYear: function(obj) {
    var digitReg = /^\d+$/;
    if(!digitReg.test(obj)) {
      return false;
    }
    var currentYear = (new Date(Date.now()).getFullYear())*1;

    if(parseInt(obj) > currentYear || parseInt(obj) < 1800) {
      return false;
    }

    return true;
  },

  elementIsInteger: function(obj) {
    var digitReg = /^\d+$/;
    return digitReg.test(obj);
  },

  elementIsEmpty: function(obj) {
    if(obj == null) {
      return true;
    }

    if(typeof(obj) == "object") {
      if(obj.full_text == undefined || obj.full_text == null || obj.full_text == "") {
        return true;
      }
    }
    if(typeof(obj) == "string") {
      if(obj.trim() == "") {
        return true;
      }
    }

    return false;
  },

  elementIsAddress: function(obj){
    if(obj !== undefined && obj !== null){
      if((obj.city != undefined && obj.city != null && obj.city != "")
        && (obj.state != undefined && obj.state != null && obj.state == "CA")
        && (obj.zip != undefined && obj.zip != null && obj.zip != "")) {
        return true;
      }
    }

    return false;
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

  elementLengthExceedsMaxlength: function(obj, maxLength) {
    var result = false;
    if (!obj) { return false }

    if (obj.length > maxLength) {
      result = true;
    }
    return result;
  },

  elementNotReachMinLength: function(obj, minLength) {
    var result = false;
    if (!obj) { return true; }
    if (obj.length < minLength) {
      result = true;
    }
    return result;
  },

  elementMatchsPattern: function(obj, pattern) {
    if (!obj) { return false; }
    return pattern.test(obj);
  },
}