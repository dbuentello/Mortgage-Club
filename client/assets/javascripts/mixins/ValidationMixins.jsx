module.exports = {
  validateRequiredFields: function(requiredFormFields){
    console.log(requiredFormFields);
    var validationResultArray = {};
    for(var key in requiredFormFields){
      if (requiredFormFields[key]==null || requiredFormFields[key]=="")
      {
        validationResultArray[key] = false
      }else{
        validationResultArray[key] = true;
    }
  }
  return validationResultArray;

  }
}