var _ = require('lodash');

var TabAsset = {
  assetCompleted: function(loan) {
    if(!this.propertyCompleted(loan.subject_property, false, loan.purpose)){
      return false;
    }

    if(this.requiredPrimaryProperty(loan) && !this.propertyCompleted(loan.primary_property, false, loan.purpose)) {
      return false;
    }

    if(loan.own_investment_property === true && !this.rentalPropertiesCompleted(loan)) {
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
      if(asset.institution_name === null || asset.asset_type === null || asset.current_balance === null) {
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

  propertyCompleted: function(property, isRental, loanPurpose) {
    isRental = isRental || false;
    isRefinance = loanPurpose === "refinance" ? true : false;

    if(property === null || property === undefined) { return false; }
    if(property.property_type === null || property.usage === null ||
      property.market_price === null ||
      property.estimated_property_tax === null ||
      property.estimated_hazard_insurance === null
    ){
      return false;
    }

    if(isRefinance && property.mortgage_includes_escrows === null){
      return false;
    }

    if(isRental){
      if(property.mortgage_includes_escrows === null){
        return false;
      }

      if(property.gross_rental_income === null){
        return false;
      }
    }

    if(!this.addressCompleted(property.address, isRental)) {
      return false;
    }

    return true;
  },

  addressCompleted: function(address, isRental) {
    if(address === null || address === undefined) {
      return false;
    }

    if(isRental){
      if(address.street_address === null && address.city === null && address.state === null && address.zip === null)
        return false;
    }
    else{
      if(address.street_address === null || address.city === null || address.state === null || address.zip === null)
        return false;
    }
    return true;
  },

  checkSameAddress: function(address1, address2){
    if (address1 === null || address1 === undefined || address2 === undefined || address2 === null)
      return false;

    if(address1.city === address2.city &&
      address1.state === address2.state &&
      address1.street_address === address2.street_address &&
      address1.street_address2 === address2.street_address2 &&
      address1.zip === address2.zip)
      return true;
    return false;
  },

  requiredPrimaryProperty: function(loan) {
    if(loan.primary_property !== undefined && loan.primary_property !== null && !this.checkSameAddress(loan.subject_property.address, loan.primary_property.address)) {
      return true;
    }
    return false;
  }
}
module.exports = TabAsset;