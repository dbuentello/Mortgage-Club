var TabIncome = {
  /**
   * Check tab income is completed or not
   * @type {boolean}
   */
  incomeCompleted: function(loan){
    var borrower = loan.borrower;
    var secondaryBorrower = loan.secondary_borrower;
    var currentEmployment = borrower.current_employment;
    var previousEmployment = borrower.previous_employment;

    if(this.objectFieldNotValid(currentEmployment))
      return false;

    if(!this.employmentCompleted(currentEmployment))
      return false;

    if(!this.currentEmploymentDurationValid(currentEmployment, previousEmployment))
      return false;

    if(this.valueFieldNotValid(borrower.gross_income))
      return false;

    if (!this.objectFieldNotValid(secondaryBorrower)){

      if(this.objectFieldNotValid(secondaryBorrower.current_employment))
        return false;

      if(!this.employmentCompleted(secondaryBorrower.current_employment))
        return false;

      if(!this.currentEmploymentDurationValid(secondaryBorrower.current_employment, secondaryBorrower.previous_employment))
        return false;

      if(this.valueFieldNotValid(secondaryBorrower.gross_income))
        return false;
    }

    return true;
  },

  employmentCompleted: function(employment){
    if (this.valueFieldNotValid(employment.employer_name))
      return false;

    if (this.valueFieldNotValid(employment.address))
      return false;

    // if (this.valueFieldNotValid(employment.employer_contact_name))
    //   return false;

    // if (this.valueFieldNotValid(employment.employer_contact_number))
    //   return false;

    if (this.valueFieldNotValid(employment.current_salary))
      return false;

    if (this.valueFieldNotValid(employment.job_title))
      return false;

    if (this.valueFieldNotValid(employment.pay_frequency))
      return false;

    if (this.valueFieldNotValid(employment.duration))
      return false;

    return true;
  },

  currentEmploymentDurationValid: function(currentEmployment, previousEmployment){
    return (currentEmployment.duration >= 2 || (currentEmployment.duration < 2 && this.previousEmploymentCompleted(previousEmployment)));
  },

  previousEmploymentCompleted: function(prevEmployment){
    if (this.objectFieldNotValid(prevEmployment))
      return false;

    if (this.valueFieldNotValid(prevEmployment.employer_name))
      return false;

    if (this.valueFieldNotValid(prevEmployment.job_title))
      return false;

    if (this.valueFieldNotValid(prevEmployment.duration))
      return false;

    if (this.valueFieldNotValid(prevEmployment.monthly_income))
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
}

module.exports = TabIncome;