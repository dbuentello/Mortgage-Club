var TabDocuments = {
  /**
   * Check tab document is completed or not
   * @type {boolean}
   */
  documentsCompleted: function(loan){
    var borrower = loan.borrower;
    var secondaryBorrower = loan.secondary_borrower;

    if(secondaryBorrower === undefined || secondaryBorrower === null)
      return this.borrowerDocumentsCompleted(borrower);

    return (this.borrowerDocumentsCompleted(borrower) && this.borrowerDocumentsCompleted(secondaryBorrower));
  },

  borrowerDocumentsCompleted: function(borrower){
    var noUploadedFiles = _.filter(borrower.documents, function(document){ return document.is_required == true && document.original_filename === null });

    return noUploadedFiles == 0;
  }
}

module.exports = TabDocuments;
