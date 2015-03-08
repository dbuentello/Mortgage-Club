/**
 * @jsx React.DOM
 */

var freightChargeTemplates = {
  35: "lcl",
  104: "lcl",
  36:  "fcl_20",
  105: "fcl_20",
  37:  "fcl_40",
  106: "fcl_40",
  38:  "fcl_40_hq",
  107: "fcl_40_hq",
  103: "fcl_45_hq",
  108: "fcl_45_hq"
};
var griFreightChargeTemplates = [104, 105, 106, 107, 108];
var percentageRelatedTemplates = [23, 63,78, 83];
var minimumChargeTemplates = [1, 35];
var minimumCharge = 150;

var QuoteCalculationMixin = {

  calculateCost: function(rate, rateType, weight, volume, pallets, item, allItems, templates, isLCL, byContainerCharge) {
    if (item && item.partner_rate) {
      return this.calculateCostWithPartnerRate(rate, rateType, weight, volume, pallets, item, allItems, templates, isLCL, byContainerCharge);
    } else {
      return this.calculateCostNormally(rate, rateType, weight, volume, pallets, item, allItems, templates);
    }
  },

  calculateCostWithPartnerRate: function(rate, rateType, weight, volume, pallets, item, allItems, templates, isLCL, byContainerCharge) {
    var value = 0;
    if (isLCL) {
      value = this.calculateCostFromPartner('lcl', item.partner_rate, item.template_id);
    } else if (freightChargeTemplates[item.template_id] !== undefined) {
      value = rate;
    } else {
      _.each(this.containerCounts(allItems), function(count, container) {
        var partner_cost = this.calculateCostFromPartner(container, item.partner_rate, item.template_id);
        if (byContainerCharge) {
          value += count * partner_cost;
        } else {
          value = Math.max(value, partner_cost);
        }
      }, this);
    }
    return this.calculateCostNormally(value, rateType, weight, volume, pallets, item, allItems, templates);
  },

  containerCounts: function(items) {
    var counts = {};
    _.each(_.select(items, function(item) {
      return freightChargeTemplates[item.template_id] !== undefined && !_.include(griFreightChargeTemplates, item.template_id);
    }), function(item) {
      var containerType = freightChargeTemplates[item.template_id];
      if (counts[containerType] !== undefined) {
        counts[containerType] += item.item_count;
      } else {
        counts[containerType] = item.item_count || 0;
      }
    });
    return counts;
  },

  calculateCostFromPartner: function(containerType, partnerRate, templateId) {
    var value = 0, key;
    if (containerType === 'lcl') {
      if (partnerRate.template_map.origin_charges.lcl[templateId]) {
        key = partnerRate.template_map.origin_charges.lcl[templateId];
        value = _.findWhere(partnerRate.origin_charges, {container_type: containerType})[key];
      } else if (partnerRate.template_map.destination_charges.lcl[templateId]) {
        key = partnerRate.template_map.destination_charges.lcl[templateId];
        value = _.findWhere(partnerRate.destination_charges, {container_type: containerType})[key];
      }
    } else {
      if (partnerRate.template_map.origin_charges.fcl[templateId]) {
        key = partnerRate.template_map.origin_charges.fcl[templateId];
        value = _.findWhere(partnerRate.origin_charges, {container_type: containerType})[key];
      } else if (partnerRate.template_map.destination_charges.fcl[templateId]) {
        key = partnerRate.template_map.destination_charges.fcl[templateId];
        value = _.findWhere(partnerRate.destination_charges, {container_type: containerType})[key];
      }
    }
    return value;
  },

  calculateCostNormally: function(rate, rateType, weight, volume, pallets, item, allItems, templates) {
    weight = parseFloat(weight);
    volume = parseFloat(volume);
    rate = parseFloat(rate) || 0;

    var count = (item ? parseInt(item.item_count) : 1),
        relatedItem, relatedItemCost, relatedItemPrice, template;

    if (rateType == 'weight') {
      return rate * weight * count;
    } else if (rateType == 'volume') {
      return rate * volume * count;
    } else if (rateType == 'percentage') {
      relatedItem = _.find(allItems, function (_item) {
        return _.contains(percentageRelatedTemplates, parseInt(_item.template_id, 10));
      });

      if (!relatedItem) {
        return 0;
      } else {
        template = _.findWhere(templates, {id: parseInt(relatedItem.template_id)});
        relatedItemCost = this.calculateCost(relatedItem.rate, template.rate_type, weight, volume, pallets, relatedItem, allItems, templates);
        relatedItemPrice = this.calculatePrice(relatedItemCost, relatedItem.markup, relatedItem.template_id);
        return relatedItemPrice * rate / 100;
      }
    } else if (rateType == 'pallet') {
      return rate * (pallets || 0);
    } else {
      return rate * count;
    }
  },

  calculatePrice: function(cost, markup, templateId) {
    var price;
    cost = parseFloat(cost);
    markup = parseFloat(markup) || 0;
    price = Math.round(cost * (1 + markup / 100) * 100) / 100;

    if (_.contains(minimumChargeTemplates, templateId)) {
      price = Math.max(price, minimumCharge);
    }

    return price;
  },

  calculateTotalCost: function(lineItems, templates, calculatedWeight, calculatedVolume, chargeableWeight, chargeableVolume, pallets) {
    var total, cost, template, weight, volume;

    total = _.reduce(lineItems, function (memo, lineItem) {
      template = _.findWhere(templates, {id: parseInt(lineItem.template_id)});
      weight = template.air && template.category == 'freight' ?  chargeableWeight : calculatedWeight;
      volume = !template.air && template.categpry == 'freight' ? chargeableVolume : calculatedVolume;
      cost = this.calculateCost(lineItem.rate, template.rate_type, weight, volume, pallets, lineItem, lineItems, templates);

      return memo + cost;
    }, 0, this);

    return total;
  },

  calculateTotalPrice: function(lineItems, templates, calculatedWeight, calculatedVolume, chargeableWeight, chargeableVolume, pallets) {
    var total, cost, price, template, weight, volume;

    total = _.reduce(lineItems, function (memo, lineItem) {
      template = _.findWhere(templates, {id: parseInt(lineItem.template_id)});
      weight = template.air && template.category == 'freight' ?  chargeableWeight : calculatedWeight;
      volume = !template.air && template.categpry == 'freight' ? chargeableVolume : calculatedVolume;
      cost = this.calculateCost(lineItem.rate, template.rate_type, weight, volume, pallets, lineItem, lineItems, templates);
      price = this.calculatePrice(cost, lineItem.markup, lineItem.template_id);

      return memo + price;
    }, 0, this);

    return total;
  }
};

module.exports = QuoteCalculationMixin;
