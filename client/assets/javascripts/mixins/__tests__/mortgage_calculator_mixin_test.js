jest.dontMock('../MortgageCalculatorMixin');

describe('mortgage calculator for total cost', function() {
  var subject = require('../MortgageCalculatorMixin');

  it('calculates monthly payment correctly', function() {
    var tests = [
      {params: [5000, 0.045, 60], expected: 93.22},
      {params: [15000, 0.125, 360], expected: 160.09},
      {params: [30000, 0.1, 360], expected: 263.27}
    ];

    tests.forEach(function (test) {
      expect(subject.monthlyPayment.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates total Interest Paid correctly', function() {
    var tests = [
      {params: [400000, 0.024900000000000002, 9, 2665.27], expected: 65931.25},
    ];

    tests.forEach(function (test) {
      expect(subject.totalInterestPaid.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates total Interest Paid Tax Adjusted correctly', function() {
    var tests = [
      {params: [19092.43, 0.3], expected: 13364.701},
      {params: [29496.32, 0.3], expected: 20647.424},
      {params: [30320.11, 0.3], expected: 21224.076999999997}
    ];

    tests.forEach(function (test) {
      expect(subject.totalInterestPaidTaxAdjusted.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates total fees correctly', function() {
    var fees = new Array();
    fees['Processing fee'] = 14;
    fees['Loan origination fee'] = 295;
    fees['Appraisal fee'] = 400;
    fees['Credit report fee'] = 17;
    var tests = [
      {params: [fees, 12], expected: 738}
    ];

    tests.forEach(function (test) {
      expect(subject.totalFees.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates upFrontCash correctly', function() {
    var fees = new Array();
    fees['Processing fee'] = 14;
    fees['Loan origination fee'] = 295;
    fees['Appraisal fee'] = 400;
    fees['Credit report fee'] = 17;
    var tests = [
      {params: [20000, fees, 12], expected: 20738}
    ];

    tests.forEach(function (test) {
      expect(subject.upFrontCash.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates opportunity Cost Of Upfront Cash correctly', function() {
    var tests = [
      {params: [0.08, 5, 45000], expected: 21119.76},
      {params: [0.08, 5, 43859.33], expected: 20584.41},
      {params: [0.08, 5, 43559.33], expected: 20443.62}
    ];

    tests.forEach(function (test) {
      expect(subject.opportunityCostOfUpfrontCash.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('calculates opportunity Cost Of Monthly Payment correctly', function() {
    // monthlyPayment, investmentReturnRate, expectedMortgageDuration, numOfPeriods

    var tests = [
      {params: [477.42, 0.08, 5], expected: 6434.12},
      {params: [278.20, 0.08, 5], expected: 3749.26},
      {params: [8775.72, 0.08, 1], expected: 3948.42}
    ];

    tests.forEach(function (test) {
      expect(subject.opportunityCostOfMonthlyPayment.apply(subject, test.params)).toBe(test.expected);
    });
  });
});
