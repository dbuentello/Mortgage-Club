var TabProperty = {
  propertyCompleted: function(loan) {
    if(loan.subject_property === undefined) { return false; }
    if(!this.subjectPropertyCompleted(loan.subject_property)) { return false; }
    if(!this.purposeCompleted(loan)) { return false; }

    return true;
  },

  subjectPropertyCompleted: function(property) {
    if(property.usage === null) { return false; }
    if(property.usage !== "primary_residence" && property.gross_rental_income === null) { return false; }
    if(!this.addressCompleted(property.address)) { return false; }

    return true;
  },

  addressCompleted: function(address) {
    if(address == null || address == undefined) { return false; }
    if(address.street_address == null && address.city == null && address.state == null && address.street_address2 == null)
      return false;

    return true;
  },

  purposeCompleted: function(loan) {
    if(loan.purpose == null) { return false; }
    if(loan.purpose == "purchase" && loan.subject_property.purchase_price == null) {
      return false;
    }
    if(loan.purpose == "refinance" && this.loanDoesNotHaveRefinanceData(loan)) {
      return false;
    }

    return true;
  },

  loanDoesNotHaveRefinanceData: function(loan) {
    if(loan.subject_property.original_purchase_price == null || loan.subject_property.original_purchase_year == null)
      return true;

    return false;
  }
}
module.exports = TabProperty;