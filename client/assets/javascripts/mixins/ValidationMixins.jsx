module.exports = {
  validateRequiredFields: function(requiredFormFields){
    for(var key in requiredFormFields){
      if (requiredFormFields[key]==null || requiredFormFields[key]=="")
      {
        return false;
      }
  }
  return true;
  },
  elementIsEmpty: function(obj){
    return (obj==null||obj.trim()=="");
  },
  arrayContainsEmptyElement: function(requiredArray){
    for(var obj in requiredArray){
      if(this.elementIsEmpty(requiredArray[obj])){
        return true;
      }
    }
    return false;
  }
}