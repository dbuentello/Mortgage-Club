jest.dontMock("../CompletedLoanMixins/TabDeclaration");

describe("check if tab declaration is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabDeclaration");
  var booleanArr = [true, false];
  var completedDeclaration = {
    borrower: {
      declaration: {
        outstanding_judgment: Math.floor(Math.random() * booleanArr.length),
        bankrupt: Math.floor(Math.random() * booleanArr.length),
        property_foreclosed: Math.floor(Math.random() * booleanArr.length),
        party_to_lawsuit: Math.floor(Math.random() * booleanArr.length),
        loan_foreclosure: Math.floor(Math.random() * booleanArr.length),
        child_support: Math.floor(Math.random() * booleanArr.length),
        down_payment_borrowed: Math.floor(Math.random() * booleanArr.length),
        co_maker_or_endorser: Math.floor(Math.random() * booleanArr.length),
        present_delinquent_loan: Math.floor(Math.random() * booleanArr.length),
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: false
      }
    }
  };

  var declarationHasPropertyTypeAndTitle = {
    borrower: {
      declaration: {
        outstanding_judgment: Math.floor(Math.random() * booleanArr.length),
        bankrupt: Math.floor(Math.random() * booleanArr.length),
        property_foreclosed: Math.floor(Math.random() * booleanArr.length),
        party_to_lawsuit: Math.floor(Math.random() * booleanArr.length),
        loan_foreclosure: Math.floor(Math.random() * booleanArr.length),
        child_support: Math.floor(Math.random() * booleanArr.length),
        down_payment_borrowed: Math.floor(Math.random() * booleanArr.length),
        co_maker_or_endorser: Math.floor(Math.random() * booleanArr.length),
        present_delinquent_loan: Math.floor(Math.random() * booleanArr.length),
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: true,
        type_of_property: Math.floor(Math.random() * booleanArr.length),
        title_of_property: Math.floor(Math.random() * booleanArr.length)
      }
    }
  };

  var declarationHasNullPropertyTypeAndTitle = {
    borrower: {
      declaration: {
        outstanding_judgment: Math.floor(Math.random() * booleanArr.length),
        bankrupt: Math.floor(Math.random() * booleanArr.length),
        property_foreclosed: Math.floor(Math.random() * booleanArr.length),
        party_to_lawsuit: Math.floor(Math.random() * booleanArr.length),
        loan_foreclosure: Math.floor(Math.random() * booleanArr.length),
        child_support: Math.floor(Math.random() * booleanArr.length),
        down_payment_borrowed: Math.floor(Math.random() * booleanArr.length),
        co_maker_or_endorser: Math.floor(Math.random() * booleanArr.length),
        present_delinquent_loan: Math.floor(Math.random() * booleanArr.length),
        citizen_status: "C",
        ownership_interest: true,
        type_of_property: null,
        title_of_property: null
      }
    }
  };

  it("returns true with completed declaration", function() {
    expect(subject.declarationCompleted.apply(subject, [completedDeclaration])).toBe(true);
  });

  it("returns true with valid property type and title", function() {
    expect(subject.declarationCompleted.apply(subject, [declarationHasPropertyTypeAndTitle])).toBe(true);
  });

  it("returns false with invalid property type and property title", function() {
    expect(subject.declarationCompleted.apply(subject, [declarationHasNullPropertyTypeAndTitle])).toBe(false);
  });
});