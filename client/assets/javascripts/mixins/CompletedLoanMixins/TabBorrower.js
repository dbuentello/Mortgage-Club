var TabBorrower = {
  completed: function(loan){
    var borrower = loan.borrower;
    var secondaryBorrower = loan.secondary_borrower;

    if(this.objectFieldNotValid(secondaryBorrower))
      return this.borrowerCompleted(borrower);
    return (this.borrowerCompleted(borrower) && this.borrowerCompleted(secondaryBorrower));
  },
  //TODO REVIEW AND REFACTOR
  borrowerCompleted: function(borrower){
    if (borrower === undefined)
      return false;

    if (this.objectFieldNotValid(borrower.self_employed))
      return false;

    if (this.valueFieldNotValid(borrower.first_name))
      return false;

    if (this.valueFieldNotValid(borrower.last_name))
      return false;

    if (this.valueFieldNotValid(borrower.ssn))
      return false;

    if (this.valueFieldNotValid(borrower.dob))
      return false;

    if (this.valueFieldNotValid(borrower.years_in_school))
      return false;

    if (this.valueFieldNotValid(borrower.marital_status))
      return false;

    if (this.valueFieldNotValid(borrower.dependent_count))
      return false;

    if (borrower.dependent_ages !== undefined && borrower.dependent_ages.length == 0 && borrower.dependent_count >= 1)
      return false;

    if (this.objectFieldNotValid(borrower.current_address))
      return false;

    if (this.valueFieldNotValid(borrower.current_address.is_rental))
      return false;

    if (this.valueFieldNotValid(borrower.current_address.years_at_address))
      return false;

    if (borrower.current_address.years_at_address < 0)
      return false;

    if (!this.addressCompleted(borrower.current_address.cached_address))
      return false;

    if (this.rentHouseAndMonthlyRentNotValid(borrower.current_address))
      return false;

    if (!this.previousAddressCompleted(borrower))
      return false;
    return true;
  },

  valueFieldNotValid: function(field){
    if (field === undefined || field === null || field === "")
      return true;
    return false;
  },

  objectFieldNotValid: function(obj){
    if(obj === undefined || obj === null)
      return true;
    return false;
  },

  previousAddressCompleted: function(borrower){
    if (this.objectFieldNotValid(borrower))
      return false;

    if (borrower.current_address.years_at_address > 1)
      return true;

    if (this.valueFieldNotValid(borrower.previous_address))
      return false;

    if (this.valueFieldNotValid(borrower.previous_address.is_rental))
      return false;

    if (this.rentHouseAndMonthlyRentNotValid(borrower.previous_address))
      return false;
    return true;
  },

  addressCompleted: function(address) {
    if(address == null || address == undefined) { return false; }
    if(address.street_address == null || address.city == null || address.state == null || address.zip == null)
      return false;

    return true;
  },

  rentHouseAndMonthlyRentNotValid: function(address){
    return ((address.is_rental === true) && (this.valueFieldNotValid(address.monthly_rent)));
  }
}

module.exports = TabBorrower;