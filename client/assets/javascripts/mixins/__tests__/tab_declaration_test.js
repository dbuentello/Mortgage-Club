jest.dontMock("../CompletedLoanMixins/TabDeclaration");

describe("check if tab declaration is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabDeclaration");
  var booleanArr = [true, false];

  var completedBorrowerDeclaration = {
    borrower: {
      declaration: {
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: false
      }
    }
  };

  var completedCoBorrowerDeclaration = {
    borrower: {
      declaration: {
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: false
      }
    },
    secondary_borrower: {
      declaration: {
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: false
      }
    }
  };

  var invalidCoBorrowerDeclaration = {
    borrower: {
      declaration: {
        citizen_status: "C",
        is_hispanic_or_latino: "Y",
        gender_type: "M",
        race_type: "A",
        ownership_interest: false
      }
    },
    secondary_borrower: {
      declaration: null
    }
  };

  var declarationHasPropertyTypeAndTitle = {
    borrower: {
      declaration: {
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
        citizen_status: "C",
        ownership_interest: true,
        type_of_property: null,
        title_of_property: null
      }
    }
  };

  it("returns true with completed borrower declaration", function() {
    expect(subject.completed.apply(subject, [completedBorrowerDeclaration])).toBe(true);
  });

  it("returns true with completed co-borrower declaration", function() {
    expect(subject.completed.apply(subject, [completedCoBorrowerDeclaration])).toBe(true);
  });

  it("returns true with valid property type and title", function() {
    expect(subject.completed.apply(subject, [declarationHasPropertyTypeAndTitle])).toBe(true);
  });

  it("returns false with invalid co borrower declaration", function() {
    expect(subject.completed.apply(subject, [invalidCoBorrowerDeclaration])).toBe(false);
  });

  it("returns false with invalid property type and property title", function() {
    expect(subject.completed.apply(subject, [declarationHasNullPropertyTypeAndTitle])).toBe(false);
  });
});