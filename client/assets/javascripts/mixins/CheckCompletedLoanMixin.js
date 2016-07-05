var TabProperty = require('mixins/CompletedLoanMixins/TabProperty');
var TabBorrower = require('mixins/CompletedLoanMixins/TabBorrower');
var TabDeclaration = require('mixins/CompletedLoanMixins/TabDeclaration');
var TabDocuments = require('mixins/CompletedLoanMixins/TabDocuments');
var TabIncome = require('mixins/CompletedLoanMixins/TabIncome');
var TabAsset = require('mixins/CompletedLoanMixins/TabAsset');
var TabCreditCheck = require('mixins/CompletedLoanMixins/TabCreditCheck');

var CheckCompletedLoanMixin = {
  loanIsCompleted: function(loan) {
    return TabProperty.propertyCompleted(loan) &&
      TabBorrower.completed(loan) &&
      TabDocuments.documentsCompleted(loan) &&
      TabIncome.incomeCompleted(loan) &&
      TabAsset.assetCompleted(loan) &&
      TabDeclaration.declarationCompleted(loan) &&
      TabCreditCheck.creditCheckCompleted(loan);
  }
}
module.exports = CheckCompletedLoanMixin;
