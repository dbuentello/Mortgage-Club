jest.dontMock("../CompletedLoanMixins/TabIncome");

describe("check if tab income is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabIncome");

  var completedIncome = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5,
      }
    }
  };

  var completedIncomePreviousAddress = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "Tang Nguyen",
        job_title: "tester",
        duration: 4,
        monthly_income: 10000
      }
    }
  };

  var completedIncomeSecondaryBorrower = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5,
      }
    },
    secondary_borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5,
      }
    }
  };

  var completedIncomeSecondaryBorrowerPreviousAddress = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "Tang Nguyen",
        job_title: "tester",
        duration: 4,
        monthly_income: 10000
      }
    },
    secondary_borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "Tang Nguyen",
        job_title: "tester",
        duration: 4,
        monthly_income: 10000
      }
    }
  };

  var invalidIncome = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5
      }
    }
  };

  var invalidIncomePreviousAddress = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "Tang Nguyen",
        job_title: "",
        duration: 4,
        monthly_income: 10000
      }
    }
  };

  var invalidIncomeSecondaryBorrower = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5,
      }
    },
    secondary_borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 5,
      }
    }
  };

  var invalidIncomeSecondaryBorrowerPreviousAddress = {
    borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "Tang Nguyen",
        job_title: "tester",
        duration: 4,
        monthly_income: 10000
      }
    },
    secondary_borrower: {
      gross_income: 1000,
      current_employment: {
        employer_name: "Tang Nguyen",
        address: "1234 Le Dai Hanh",
        employer_contact_name: "Cuong Vu",
        employer_contact_number: "(123) 456-7809",
        current_salary: 10000,
        job_title: "dev",
        pay_frequency: 10000,
        duration: 1
      },
      previous_employment: {
        employer_name: "",
        job_title: "tester",
        duration: 4,
        monthly_income: 10000
      }
    }
  };
  it("returns true with completed income", function() {
    expect(subject.incomeCompleted.apply(subject, [completedIncome])).toBe(true);
  });

  it("returns true with completed income previous address", function() {
    expect(subject.incomeCompleted.apply(subject, [completedIncomePreviousAddress])).toBe(true);
  });

  it("returns true with completed income secondary borrower", function() {
    expect(subject.incomeCompleted.apply(subject, [completedIncomeSecondaryBorrower])).toBe(true);
  });

  it("returns true with completed income secondary borrower previous address", function() {
    expect(subject.incomeCompleted.apply(subject, [completedIncomeSecondaryBorrowerPreviousAddress])).toBe(true);
  });

  it("returns false with completed income", function() {
    expect(subject.incomeCompleted.apply(subject, [invalidIncome])).toBe(false);
  });

  it("returns false with completed income previous address", function() {
    expect(subject.incomeCompleted.apply(subject, [invalidIncomePreviousAddress])).toBe(false);
  });

  it("returns false with completed income secondary borrower", function() {
    expect(subject.incomeCompleted.apply(subject, [invalidIncomeSecondaryBorrower])).toBe(false);
  });

  it("returns false with completed income secondary borrower previous address", function() {
    expect(subject.incomeCompleted.apply(subject, [invalidIncomeSecondaryBorrowerPreviousAddress])).toBe(false);
  });
});
