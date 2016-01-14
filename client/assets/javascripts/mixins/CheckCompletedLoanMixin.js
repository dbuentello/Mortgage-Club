var CheckCompletedLoanMixin = {
  loanIsCompleted: function(loan) {
    if(loan.property_completed && loan.borrower_completed && loan.documents_completed && loan.income_completed
        && loan.credit_completed && loan.assets_completed && loan.declarations_completed) {
      return true;
    }
    else {
      return false;
    }
  }
}