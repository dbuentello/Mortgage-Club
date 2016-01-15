module.exports = {
  elementIsEmpty: function(obj){
    if(obj==null){
      return true
    }
    if(typeof(obj) == "string") {
      if(obj.trim()==""){
        return true;
      }
    }
    return false;
  },

  arrayContainsEmptyElement: function(requiredArray){
    for(var obj in requiredArray){
      if(this.elementIsEmpty(requiredArray[obj])){
        return true;
      }
    }
    return false;
  },
  requiredFieldsHasEmptyElement: function(stateArray, outputFields){
    var empty = false;
    var stateObj = {};
    for(var i = 0; i < stateArray.length; i++){
      if (this.elementIsEmpty(stateArray[i]))
      {
        empty = true;
        stateObj[outputFields[i]] = true;
      }
    }
    return {state: stateObj, hasEmptyElement: empty};
  }

}