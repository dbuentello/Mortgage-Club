jest.dontMock("../CompletedLoanMixins/TabBorrower");

describe("check if tab borrower is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabBorrower");

  var baseBorrower = {
    self_employed: false,
    first_name: "Tang",
    last_name: "Nguyen",
    ssn: "123-12-1232",
    dob: "24/12/1992",
    years_in_school: 10,
    marital_status: "married",
  };

  var completedBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    }
  };

  var completedBorrowerHasDependent = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 2,
      dependent_ages: [1, 2],
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    }
  };

  var completedBorrowerHouseRental = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: 1000
      }
    }
  };

  var completedCoBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    },
    secondary_borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    }
  };

  var completedCoBorrowerHasDependent = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 2,
      dependent_ages: [1, 2],
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    },
    secondary_borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 2,
      dependent_ages: [1, 2],
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    }
  };

  var completedCoBorrowerHouseRental = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: 1000
      }
    },
    secondary_borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: 1000
      }
    }
  };

  var invalidAddressBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0
    }
  };

  var invalidDependentBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 2,
      dependent_ages: [],
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: false,
        years_at_address: 5
      }
    }
  };

  var invalidHouseRentalBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: ""
      }
    }
  };

  var invalidStreetAddressBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          city: "New York",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: ""
      }
    }
  };

  var invalidCityAddressBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          state: "CA",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: ""
      }
    }
  };

  var invalidStateAddressBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          zip: "94103"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: ""
      }
    }
  };

  var invalidZipAddressBorrower = {
    borrower: {
      self_employed: false,
      first_name: "Tang",
      last_name: "Nguyen",
      ssn: "123-12-1232",
      dob: "24/12/1992",
      years_in_school: 10,
      marital_status: "married",
      dependent_count: 0,
      current_address: {
        cached_address: {
          street_address: "123 Silver Mecount",
          city: "New York",
          state: "CA"
        },
        is_rental: true,
        years_at_address: 5,
        monthly_rent: ""
      }
    }
  };

  it("returns true with completed borrower", function() {
    expect(subject.completed.apply(subject, [completedBorrower])).toBe(true);
  });

  it("returns true with completed borrower has dependent", function() {
    expect(subject.completed.apply(subject, [completedBorrowerHasDependent])).toBe(true);
  });

  it("returns true with completed borrower house rental", function() {
    expect(subject.completed.apply(subject, [completedBorrowerHouseRental])).toBe(true);
  });

  it("returns true with completed co borrower", function() {
    expect(subject.completed.apply(subject, [completedCoBorrower])).toBe(true);
  });

  it("returns true with completed co borrower has dependent", function() {
    expect(subject.completed.apply(subject, [completedCoBorrowerHasDependent])).toBe(true);
  });

  it("returns true with completed co borrower house rental", function() {
    expect(subject.completed.apply(subject, [completedCoBorrowerHouseRental])).toBe(true);
  });

  it("returns false with invalid address borrower", function() {
    expect(subject.completed.apply(subject, [invalidAddressBorrower])).toBe(false);
  });

  it("returns false with invalid dependent borrower", function() {
    expect(subject.completed.apply(subject, [invalidDependentBorrower])).toBe(false);
  });

  it("returns false with invalid house rental borrower", function() {
    expect(subject.completed.apply(subject, [invalidHouseRentalBorrower])).toBe(false);
  });

  it("returns false with invalid street address borrower", function() {
    expect(subject.completed.apply(subject, [invalidStreetAddressBorrower])).toBe(false);
  });

  it("returns false with invalid city address borrower", function() {
    expect(subject.completed.apply(subject, [invalidCityAddressBorrower])).toBe(false);
  });

  it("returns false with invalid state address borrower", function() {
    expect(subject.completed.apply(subject, [invalidStateAddressBorrower])).toBe(false);
  });

  it("returns false with invalid zip address borrower", function() {
    expect(subject.completed.apply(subject, [invalidZipAddressBorrower])).toBe(false);
  });
});
