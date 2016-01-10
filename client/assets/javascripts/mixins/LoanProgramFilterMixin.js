var LoanProgramFilterMixin = {
  filterPrograms: function(programs, products, lender_names) {
    if(this.criteriaAreEmpty(products, lender_names)) {
      return programs;
    }

    filteredPrograms = [];
    programs.forEach(function (program) {
      if(this.belongsToProducts(program, products) && this.belongsToLenders(program, lender_names)) {
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

  criteriaAreEmpty: function(products, lender_names) {
    return (products.length == 0 && lender_names.length == 0);
  }
}
module.exports = LoanProgramFilterMixin;
