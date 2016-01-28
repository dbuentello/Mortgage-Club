jest.dontMock("../CompletedLoanMixins/TabDocuments");

describe("check if tab documents is completed or not", function() {
  var BORROWER_SELF_EMPLOYED = ["first_personal_tax_return", "second_personal_tax_return", "first_business_tax_return", "second_business_tax_return", "first_bank_statement", "second_bank_statement"];

  var BORROWER_SELF_EMPLOYED_TAXES_JOINLY = ["first_business_tax_return", "second_business_tax_return", "first_bank_statement", "second_bank_statement"];

  var BORROWER_NOT_SELF_EMPLOYED = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_federal_tax_return", "second_federal_tax_return", "first_bank_statement", "second_bank_statement"];

  var BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_bank_statement", "second_bank_statement"];

  var subject = require("../CompletedLoanMixins/TabDocuments");

  var baseBorrowerSelfEmployed = [
    {
      document_type: BORROWER_SELF_EMPLOYED[0]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED[1]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED[2]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED[3]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED[4]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED[5]
    }
  ];

  var baseBorrowerNotSelfEmployed = [
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[0]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[1]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[2]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[3]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[4]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[5]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[6]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED[7]
    }
  ];

  var baseBorrowerSelfEmployedTaxJointly = [
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[0]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[1]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[2]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[3]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[4]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[5]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[6]
    },
    {
      document_type: BORROWER_SELF_EMPLOYED_TAXES_JOINLY[7]
    },
  ];

  var baseBorrowerNotSelfEmployedTaxJointly = [
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[0]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[1]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[2]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[3]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[4]
    },
    {
      document_type: BORROWER_NOT_SELF_EMPLOYED_TAXES_JOINLY[5]
    }
  ];

  var completedSelfEmployedBorrower = {
    borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployed
    }
  };

  var completedNotSelfEmployedBorrower = {
    borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployed
    }
  };

  var completedSelfEmployedSecondaryBorrower = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: false,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployed
    }
  };

  var completedNotSelfEmployedSecondaryBorrower = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: false,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployed
    }
  };

  var completedSelfEmployedSecondaryBorrowerTaxJointly = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: true,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployedTaxJointly
    }
  };

  var completedNotSelfEmployedSecondaryBorrowerTaxJointly = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: true,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployedTaxJointly
    }
  };

  var invalidSelfEmployedBorrower = {
    borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployed.slice(1, 2)
    }
  };

  var invalidNotSelfEmployedBorrower = {
    borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployed.slice(1, 2)
    }
  };

  var invalidSelfEmployedSecondaryBorrower = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: false,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployed.slice(1, 2)
    }
  };

  var invalidNotSelfEmployedSecondaryBorrower = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: false,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployed.slice(1, 2)
    }
  };

  var invalidSelfEmployedSecondaryBorrowerTaxJointly = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: true,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: true,
      documents: baseBorrowerSelfEmployedTaxJointly.slice(1, 2)
    }
  };

  var invalidNotSelfEmployedSecondaryBorrowerTaxJointly = {
    borrower: {
      self_employed: true,
      is_file_taxes_jointly: true,
      documents: baseBorrowerSelfEmployed
    },
    secondary_borrower: {
      self_employed: false,
      documents: baseBorrowerNotSelfEmployedTaxJointly.slice(1, 2)
    }
  };

  it("returns true with completed self employed borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [completedSelfEmployedBorrower])).toBe(true);
  });

  it("returns true with completed not self employed borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [completedNotSelfEmployedBorrower])).toBe(true);
  });

  it("returns true with completed self employed borrower, self employed secondary borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [completedSelfEmployedSecondaryBorrower])).toBe(true);
  });

  it("returns true with completed self employed borrower, not self employed secondary borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [completedNotSelfEmployedSecondaryBorrower])).toBe(true);
  });

  it("returns true with completed self employed borrower, self employed secondary borrower tax jointly", function() {
    expect(subject.documentsCompleted.apply(subject, [completedSelfEmployedSecondaryBorrowerTaxJointly])).toBe(true);
  });

  it("returns true with completed self employed borrower, not self employed secondary borrower tax jointly", function() {
    expect(subject.documentsCompleted.apply(subject, [completedNotSelfEmployedSecondaryBorrowerTaxJointly])).toBe(true);
  });

  it("returns false with invalid self employed borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidSelfEmployedBorrower])).toBe(false);
  });

  it("returns false with invalid not self employed borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidNotSelfEmployedBorrower])).toBe(false);
  });

  it("returns false with completed self employed borrower, invalid self employed secondary borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidSelfEmployedSecondaryBorrower])).toBe(false);
  });

  it("returns false with completed self employed borrower, invalid not self employed secondary borrower", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidNotSelfEmployedSecondaryBorrower])).toBe(false);
  });

  it("returns false with completed self employed borrower, invalid self employed secondary borrower tax jointly", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidSelfEmployedSecondaryBorrowerTaxJointly])).toBe(false);
  });

  it("returns false with completed self employed borrower, invalid not self employed secondary borrower tax jointly", function() {
    expect(subject.documentsCompleted.apply(subject, [invalidNotSelfEmployedSecondaryBorrowerTaxJointly])).toBe(false);
  });
});
