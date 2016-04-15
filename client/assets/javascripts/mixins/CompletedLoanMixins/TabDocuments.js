var BORROWER_SELF_EMPLOYED = ["first_personal_tax_return", "second_personal_tax_return", "first_business_tax_return", "second_business_tax_return", "first_bank_statement", "second_bank_statement"];

var BORROWER_SELF_EMPLOYED_TAXES_JOINLY = ["first_business_tax_return", "second_business_tax_return", "first_bank_statement", "second_bank_statement"];

var BORROWER_NOT_SELF_EMPLOYED = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_federal_tax_return", "second_federal_tax_return", "first_bank_statement", "second_bank_statement"];

var BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_bank_statement", "second_bank_statement"];

var TabDocuments = {
  documentsCompleted: function(loan){
    var borrower = loan.borrower;
    var secondaryBorrower = loan.secondary_borrower;
    if(secondaryBorrower === undefined || secondaryBorrower === null)
      return this.borrowerDocumentsCompleted(borrower);

    return (this.borrowerDocumentsCompleted(borrower) && this.coBorrowerDocumentsCompleted(borrower.is_file_taxes_jointly, secondaryBorrower));
  },

  borrowerDocumentsCompleted: function(borrower){
    return this.notJointlyDocumentCompleted(borrower);
  },

  coBorrowerDocumentsCompleted: function(isTaxJointly, secondaryBorrower){
    return (isTaxJointly ? this.secondaryJointlyDocumentCompleted(secondaryBorrower) : this.coBorrowerNotJointlyDocumentCompleted(secondaryBorrower));
  },

  secondaryJointlyDocumentCompleted: function(secondaryBorrower){
    var requiredDocuments = secondaryBorrower.self_employed ? BORROWER_SELF_EMPLOYED_TAXES_JOINLY.slice(0, -2) : BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY.slice(0, -2)
    var currentDocuments = secondaryBorrower.documents.map(function(document){
      return document.document_type;
    });

    var uploadedDocuments = requiredDocuments.filter(function(document){
      return currentDocuments.indexOf(document) < 0;
    });

    return uploadedDocuments.length == 0;
  },

  notJointlyDocumentCompleted: function(notJointlyBorrower){
    var requiredDocuments = notJointlyBorrower.self_employed ? BORROWER_SELF_EMPLOYED : BORROWER_NOT_SELF_EMPLOYED

    var currentDocuments = notJointlyBorrower.documents.map(function(document){
      return document.document_type;
    });

    var uploadedDocuments = requiredDocuments.filter(function(document){
      return currentDocuments.indexOf(document) < 0;
    });

    return  uploadedDocuments.length == 0;
  },
  coBorrowerNotJointlyDocumentCompleted: function(notJointlyCoBorrower){
    var requiredDocuments = notJointlyCoBorrower.self_employed ? BORROWER_SELF_EMPLOYED.slice(0, -2) : BORROWER_NOT_SELF_EMPLOYED.slice(0, -2)

    var currentDocuments = notJointlyCoBorrower.documents.map(function(document){
      return document.document_type;
    });

    var uploadedDocuments = requiredDocuments.filter(function(document){
      return currentDocuments.indexOf(document) < 0;
    });

    return  uploadedDocuments.length == 0;
  }
}

module.exports = TabDocuments;
