var TabDeclaration = {
  declarationCompleted: function(loan){
    var borrower = loan.borrower;
    var declaration = borrower.declaration;

    if(declaration === undefined || declaration === null)
      return false;

    if(declaration.citizen_status == null ||
      this.valueFieldNotValid(declaration.is_hispanic_or_latino) ||
      this.valueFieldNotValid(declaration.gender_type) ||
      this.valueFieldNotValid(declaration.race_type) ||
      declaration.ownership_interest == null
    ) {
      return false;
    }

    if(declaration.ownership_interest == true && (declaration.type_of_property == null || declaration.title_of_property == null)) {
      return false;
    }

    return true;
  },

  valueFieldNotValid: function(field){
    if (field === undefined || field === null || field === "")
      return true;
    return false;
  },
}
module.exports = TabDeclaration;
