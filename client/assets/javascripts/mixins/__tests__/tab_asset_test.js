jest.dontMock("../CompletedLoanMixins/TabAsset");

describe("check if tab asset is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabAsset");
  var propertyTypes = ["sfh", "duplex", "triplex", "fourplex", "condo"];
  var assetTypes = ["checkings", "savings", "investment", "retirement", "other"];
  var usageTypes = ["primary_residence", "vacation_home", "rental_property"];

  var completedAsset = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    own_investment_property: true,
    rental_properties: [
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      }
    ],
    borrower: {
      current_address: {
        cached_address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  var otherPropertiesWithEscrowNil = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    own_investment_property: true,
    rental_properties: [
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      }
    ],
    borrower: {
      current_address: {
        cached_address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  var assetHasInvalidSubjectProperty = {
    subject_property: {
      id: "lorem",
      property_type: null,
      usage: null,
      market_price: null,
      mortgage_includes_escrows: null,
      estimated_property_tax: null,
      estimated_hazard_insurance: null,
      is_subject: true
    }
  };

  var assetHasInvalidPrimaryProperty = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: null,
      usage: null,
      market_price: null,
      mortgage_includes_escrows: null,
      estimated_property_tax: null,
      estimated_hazard_insurance: null,
      is_primary: true
    }
  };

  var assetDoesNotOwnRentalProperties = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    own_investment_property: false,
    rental_properties: [
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 1231,
        mortgage_includes_escrows: 123123,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      }
    ],
    borrower: {
      current_address: {
        cached_address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  var invalidAsset = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    own_investment_property: true,
    rental_properties: [
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        gross_rental_income: 213213,
        is_rental: true,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      }
    ],
    borrower: {
      current_address: {
        cached_address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      assets: [
        {institution_name: null, asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: null}
      ]
    }
  };

  var invalidBorrowerCurrentAddress = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    borrower: {

    }
  };

  var invalidBorrowerCachedAddress = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    borrower: {
      current_address: {

      }
    }
  };

  var invalidBorrowerAddress = {
    subject_property: {
      id: "lorem",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_subject: true,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
        zip: "12345"
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      is_primary: true
    },
    borrower: {
      current_address: {
        cached_address: {
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
          zip: "12345"
        }
      },
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  it("returns true with completed asset", function() {
    expect(subject.assetCompleted.apply(subject, [completedAsset])).toBe(true);
  });

  it("returns true with completed asset and borrower does not own any rental properties", function() {
    expect(subject.assetCompleted.apply(subject, [assetDoesNotOwnRentalProperties])).toBe(true);
  });

  it("returns false with invalid subject property", function() {
    expect(subject.assetCompleted.apply(subject, [assetHasInvalidSubjectProperty])).toBe(false);
  });

  it("returns false with invalid primary property", function() {
    expect(subject.assetCompleted.apply(subject, [assetHasInvalidPrimaryProperty])).toBe(false);
  });

  it("returns false with invalid asset", function() {
    expect(subject.assetCompleted.apply(subject, [invalidAsset])).toBe(false);
  });

  it("returns false with invalid borrower current address", function() {
    expect(subject.assetCompleted.apply(subject, [invalidBorrowerCurrentAddress])).toBe(false);
  });

  it("returns false with invalid borrower cached address", function() {
    expect(subject.assetCompleted.apply(subject, [invalidBorrowerCachedAddress])).toBe(false);
  });

  it("returns false with invalid borrower address", function() {
    expect(subject.assetCompleted.apply(subject, [invalidBorrowerAddress])).toBe(false);
  });

  it("returns false with invalid escrow of other properties", function(){
    expect(subject.assetCompleted.apply(subject, [otherPropertiesWithEscrowNil])).toBe(false);
  });
});