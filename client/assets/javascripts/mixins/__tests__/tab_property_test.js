jest.dontMock("../CompletedLoanMixins/TabProperty");

describe("check if tab property is completed or not", function() {
  var subject = require("../CompletedLoanMixins/TabProperty");
  var purposeTypes = ["purchase", "refinance"];
  var propertyTypes = ["sfh", "duplex", "triplex", "fourplex", "condo"];
  var usageTypes = ["primary_residence", "vacation_home", "rental_property"];

  var completedProperty = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: Math.floor(Math.random() * usageTypes.length),
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      purchase_price: 2232332,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    purpose: "purchase"
  };

  var invalidSubjectProperty = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: null,
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      purchase_price: 2232332,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    purpose: "purchase"
  };

  var invalidAddress = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: Math.floor(Math.random() * usageTypes.length),
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      purchase_price: 2232332,
      address: {
        street_address: null,
        city: null,
        state: null,
        street_address2: null,
      }
    },
    purpose: "purchase"
  }

  var invalidPurchaseProperty = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: Math.floor(Math.random() * usageTypes.length),
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      purchase_price: null,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    purpose: "purchase"
  };

  var invalidRefinanceProperty = {
    subject_property: {
      property_type: Math.floor(Math.random() * propertyTypes.length),
      usage: Math.floor(Math.random() * usageTypes.length),
      market_price: 12233232,
      mortgage_includes_escrows: 32232,
      estimated_property_tax: 323223,
      estimated_hazard_insurance: 223233,
      original_purchase_price: null,
      original_purchase_year: 2016,
      address: {
        street_address: "Lorem ipsum",
        city: "Lorem ipsum",
        state: "Lorem ipsum",
        street_address2: "Lorem ipsum",
      }
    },
    purpose: "refinance"
  };

  it("returns true with completed property", function() {
    expect(subject.propertyCompleted.apply(subject, [completedProperty])).toBe(true);
  });

  it("returns false with invalid refinance property", function() {
    expect(subject.propertyCompleted.apply(subject, [invalidRefinanceProperty])).toBe(false);
  });

  it("returns false with invalid purchase property", function() {
    expect(subject.propertyCompleted.apply(subject, [invalidPurchaseProperty])).toBe(false);
  });

  it("returns false with invalid subject property", function() {
    expect(subject.propertyCompleted.apply(subject, [invalidSubjectProperty])).toBe(false);
  });

  it("returns false with invalid address", function() {
    expect(subject.propertyCompleted.apply(subject, [invalidAddress])).toBe(false);
  });
});
