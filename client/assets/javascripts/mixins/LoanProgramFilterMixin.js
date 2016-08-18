/**
 * Filter list rates or quotes base on conditions
 * Filtered rates
 */
var LoanProgramFilterMixin = {
  filterPrograms: function(programs, products, lender_names, cash_outs) {
    if(this.criteriaAreEmpty(products, lender_names, cash_outs)) {
      return programs;
    }

    filteredPrograms = [];
    programs.forEach(function (program) {
      if(this.belongsToProducts(program, products) && this.belongsToLenders(program, lender_names)  && this.belongsToCashOuts(program, cash_outs)) {
        filteredPrograms.push(program);
      }
    }, this);
    return filteredPrograms;
  },

  belongsToProducts: function(program, products) {
    if(products.length == 0) {
      return true;
    }
    return (products.indexOf(program.product) != -1);
  },

  belongsToLenders: function(program, lender_names) {
    if(lender_names.length == 0) {
      return true;
    }
    return (lender_names.indexOf(program.lender_name) != -1);
  },

  belongsToCashOuts: function(program, cash_outs) {
    if(cash_outs.length == 0) {
      return true;
    }
    return (cash_outs.indexOf(program.loan_to_value) != -1);
  },

  criteriaAreEmpty: function(products, lender_names, cash_outs) {
    return (products.length == 0 && lender_names.length == 0 && cash_outs.length == 0);
  }
}
module.exports = LoanProgramFilterMixin;
