var TabDeclaration = {
  declarationCompleted: function(loan){
    var borrower = loan.borrower;
    var declaration = borrower.declaration;

    if(declaration === undefined || declaration === null)
      return false;

    if(declaration.citizen_status == null ||
      declaration.ownership_interest == null
    ) {
      return false;
    }

    if(declaration.ownership_interest == true && (declaration.type_of_property == null || declaration.title_of_property == null)) {
      return false;
    }

    return true;
  }
}
module.exports = TabDeclaration;
