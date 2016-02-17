jest.dontMock("../CompletedLoanMixins/TabAsset");

describe("check if tab asset is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabAsset");
  var propertyTypes = ["sfh", "duplex", "triplex", "fourplex", "condo"];
  var assetTypes = ["checkings", "savings", "investment", "retirement", "other"];
  var usageTypes = ["primary_residence", "vacation_home", "rental_property"];

  var completedAsset = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    primary_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
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
        monthly_rent: 213213,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
        }
      },
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        monthly_rent: 213213,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
        }
      }
    ],
    borrower: {
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  var assetHasInvalidSubjectProperty = {
    subject_property: {
      property_type: null,
      usage: null,
      market_price: null,
      mortgage_includes_escrows: null,
      estimated_property_tax: null,
      estimated_hazard_insurance: null
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
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    primary_property: {
      id: "ipsum",
      property_type: null,
      usage: null,
      market_price: null,
      mortgage_includes_escrows: null,
      estimated_property_tax: null,
      estimated_hazard_insurance: null
    }
  };

  var assetDoesNotOwnRentalProperties = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    primary_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
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
        monthly_rent: 213213,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
        }
      }
    ],
    borrower: {
      assets: [
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332}
      ]
    }
  };

  var invalidAsset = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    primary_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: 0,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
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
        monthly_rent: 213213,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
        }
      },
      {
        property_type: Math.floor(Math.random() * propertyTypes.length),
        usage: 2,
        market_price: 12233232,
        mortgage_includes_escrows: 32232,
        estimated_property_tax: 323223,
        estimated_hazard_insurance: 223233,
        monthly_rent: 213213,
        address: {
          street_address: "Lorem ipsum",
          city: "Lorem ipsum",
          state: "Lorem ipsum",
          street_address2: "Lorem ipsum",
        }
      }
    ],
    borrower: {
      assets: [
        {institution_name: null, asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: 3322332},
        {institution_name: "Lorem Ipsum", asset_type: Math.floor(Math.random() * assetTypes.length), current_balance: null}
      ]
    }
  };

  it("returns true with completed asset", function() {
    expect(subject.assetCompleted.apply(subject, [completedAsset])).toBe(true);
  });

  it("returns true with completed asset and borrower does notown any rental properties", function() {
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
});