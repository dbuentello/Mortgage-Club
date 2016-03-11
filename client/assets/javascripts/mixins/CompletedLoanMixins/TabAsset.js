var _ = require('lodash');

var TabAsset = {
  assetCompleted: function(loan) {
    if(loan.borrower === undefined || loan.borrower === null){
      return false;
    }

    if(loan.borrower.current_address === undefined || loan.borrower.current_address === null){
      return false;
    }

    if(loan.borrower.current_address.cached_address === undefined || loan.borrower.current_address.cached_address === null){
      return false;
    }

    if(!this.propertyCompleted(loan.subject_property, false, loan.purpose)){
      return false;
    }

    if(this.requiredPrimaryProperty(loan) && !this.propertyCompleted(loan.primary_property, false, loan.purpose, loan.borrower.current_address.cached_address)) {
      return false;
    }

    if(loan.own_investment_property == true && !this.rentalPropertiesCompleted(loan)) {
      return false;
    }

    if(!this.allAssetsAreCompleted(loan)) {
      return false;
    }

    return true;
  },

  allAssetsAreCompleted: function(loan) {
    var assets = loan.borrower.assets;
    if(assets.length < 1) { return false; }
    var completed = true;

    assets.forEach(function (asset) {
      if(asset.institution_name == null || asset.asset_type == null || asset.current_balance == null) {
        completed = false;
        return false;
      }
    });

    return completed;
  },

  rentalPropertiesCompleted: function(loan) {
    var rental_properties = loan.rental_properties;

    for (var i = 0; i < rental_properties.length; i++) {
      var completed = this.propertyCompleted(rental_properties[i], true, loan.purpose);
      if(!completed) {
        return false;
      }
    };

    return true;
  },

  propertyCompleted: function(property, isRental, loanPurpose, borrowerAddress) {
    isRental = isRental || false;
    isRefinance = loanPurpose == "refinance" ? true : false;

    if(property == null || property == undefined) { return false; }
    if(property.property_type == null || property.usage == null ||
      property.market_price == null ||
      property.estimated_property_tax == null ||
      property.estimated_hazard_insurance == null
    ){
      return false;
    }

    if(isRefinance && property.mortgage_includes_escrows == null){
      return false;
    }

    if(isRental){
      if(property.mortgage_includes_escrows == null){
        return false;
      }

      if(property.gross_rental_income == null){
        return false;
      }
    }

    if(property.is_primary === true){
      if(!this.addressCompleted(borrowerAddress, isRental)) {
        return false;
      }
    }
    else {
      if(!this.addressCompleted(property.address, isRental)) {
        return false;
      }
    }
    return true;
  },

  addressCompleted: function(address, isRental) {
    if(address == null || address == undefined) {
      return false;
    }

    if(isRental){
      if(address.street_address == null && address.city == null && address.state == null && address.zip == null)
        return false;
    }
    else{
      if(address.street_address == null || address.city == null || address.state == null || address.zip == null)
        return false;
    }
    return true;
  },

  requiredPrimaryProperty: function(loan) {
    if(loan.primary_property !== undefined && loan.primary_property !== null && loan.primary_property.id !== loan.subject_property.id) {
      return true;
    }
    return false;
  }
}
module.exports = TabAsset;