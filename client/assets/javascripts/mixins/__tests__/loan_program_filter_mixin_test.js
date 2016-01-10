jest.dontMock("../LoanProgramFilterMixin");

describe("filter for loan programs", function() {
  var subject = require("../LoanProgramFilterMixin");
  var programs = [
    {lender_name: "BNC", product: "30 year fixed"},
    {lender_name: "BNC", product: "15 year fixed"},
    {lender_name: "eRates", product: "15 year fixed"},
    {lender_name: "Rate30", product: "5/1 ARM"},
    {lender_name: "Wells Fargo", product: "7/1 ARM"},
    {lender_name: "Wells Fargo", product: "5/1 ARM"},
    {lender_name: "Citibank", product: "FHA"},
    {lender_name: "Citibank", product: "30 year fixed"}
  ];

  it("filters programs correctly with single criteria", function() {
    var expected_programs = [
      {lender_name: "BNC", product: "30 year fixed"},
    ];

    var tests = [
      {params: [programs, ["30 year fixed"], ["BNC"]], expected: expected_programs},
    ];

    tests.forEach(function (test) {
      expect(subject.filterPrograms.apply(subject, test.params)).toEqual(test.expected);
    });
  });

  it("filters programs correctly with several criteria", function() {
    var expected_programs = [
      {lender_name: "BNC", product: "30 year fixed"},
      {lender_name: "BNC", product: "15 year fixed"},
      {lender_name: "eRates", product: "15 year fixed"},
      {lender_name: "Wells Fargo", product: "7/1 ARM"},
    ];

    var tests = [
      {params: [programs, ["30 year fixed", "15 year fixed", "7/1 ARM"], ["BNC", "eRates", "Wells Fargo"]], expected: expected_programs},
    ];

    tests.forEach(function (test) {
      expect(subject.filterPrograms.apply(subject, test.params)).toEqual(test.expected);
    });
  });
})