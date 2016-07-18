/**
  * Check tab declaration is completed or not
  * @type {boolean}
  */
var TabDeclaration = {
  completed: function(loan){
    if (loan.borrower === undefined || loan.borrower === null)
      return false;

    if (loan.secondary_borrower === undefined || loan.secondary_borrower === null)
      return this.declarationCompleted(loan.borrower.declaration);

    return (this.declarationCompleted(loan.borrower.declaration) && this.declarationCompleted(loan.secondary_borrower.declaration));
  },

  declarationCompleted: function(declaration){
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