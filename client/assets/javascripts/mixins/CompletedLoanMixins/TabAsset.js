var _ = require('lodash');

var TabAsset = {
  assetCompleted: function(loan) {
    if(!this.propertyCompleted(loan.subject_property)) { return false; }

    if(this.requiredPrimaryProperty(loan) && !this.propertyCompleted(loan.primary_property)) {
      return false;
    }

    if(loan.own_investment_property !== undefined && !this.rentalPropertiesCompleted(loan)) {
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
      var completed = this.propertyCompleted(rental_properties[i]);
      if(!completed) {
        return false;
      }
    };

    return true;
  },

  propertyCompleted: function(property) {
    if(property == null || property == undefined) { return false; }
    if(property.property_type == null || property.usage == null ||
      property.market_price == null ||
      property.mortgage_includes_escrows == null ||
      property.estimated_property_tax == null ||
      property.estimated_hazard_insurance == null
    ){
      return false;
    }
    if(!this.addressCompleted(property.address)) {
      return false;
    }

    return true;
  },

  addressCompleted: function(address) {
    if(address == null || address == undefined) { return false; }
    if(address.street_address == null && address.city == null && address.state == null && address.street_address2 == null)
      return false;

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