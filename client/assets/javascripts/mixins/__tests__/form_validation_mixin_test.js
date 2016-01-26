jest.dontMock("../FormValidationMixin");

describe('text format helper', function() {
  var subject= require("../FormValidationMixin");

  it('validate email correctly', function() {

    var tests = [
      {params: [null], expected: false},
      {params: ["hoa@example.com"], expected: true},
      {params: ["dj-examp@example.com"], expected: true},
      {params: ["dj-examp@example.example.com"], expected: true},
      {params: ["dj-exam.p@example.com"], expected: true},
      {params: ["hula.comi1@example.com"], expected: true},
      {params: ["11dj*examp@example.com"], expected: false},
      {params: ["11dj..examp@example.com"], expected: false},
      {params: ["11dj*examp@@example.com"], expected: false},
      {params: ["dj*exampexample.com"], expected: false},
      {params: ["dj*exampexamplecom"], expected: false}
    ];
    tests.forEach(function (test) {
      expect(subject.elementIsEmail.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates integer correctly", function() {

    var tests = [
      {params: ["123334444"], expected: true},
      {params: ["334444@"], expected: false},
      {params: ["334444.4"], expected: false},
      {params: ["2..3"], expected: false},
    ];
    tests.forEach(function (test) {
      expect(subject.elementIsInteger.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates years correctly", function() {

    var tests = [
      {params: ["1990"], expected: true},
      {params: ["2000"], expected: true},
      {params: ["3000"], expected: false},
      {params: ["2301"], expected: false},
      {params: ["2017"], expected: false},
      {params: ["20"], expected: false}
    ];
    tests.forEach(function (test) {
      expect(subject.elementIsValidNotFutureYear.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates America phone number correctly", function() {

    var tests = [
      {params: ["(344) 434-4455"], expected: true},
      {params: ["(144) 434-4455"], expected: true},
      {params: ["(144) 43444455"], expected: false},
      {params: ["334444@"], expected: false},
      {params: ["000 000 4"], expected: false},
      {params: ["addffg12"], expected: false},
      {params: ["(234) 234-566666"], expected: false},
      {params: [""], expected: false},
      {params: [null], expected: false}
    ];
    tests.forEach(function (test) {
      expect(subject.elementIsPhoneNumber.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates max length correctly", function() {

    var tests = [
      {params: ["12345", 2], expected: true},
      {params: ["1", 2], expected: false},
      {params: ["123456", 4], expected: true},
      {params: ["123456", 6], expected: false},
      {params: ["123456", 6], expected: false}
    ];

    tests.forEach(function (test) {
      expect(subject.elementLengthExceedsMaxlength.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates min length correctly", function() {

    var tests = [
      {params: ["123456", 8], expected: true},
      {params: ["1", 2], expected: true},
      {params: ["123456", 4], expected: false},
      {params: ["123456", 6], expected: false},
      {params: ["1234567", 6], expected: false},
      {params: [null, 6], expected: true}
    ];

    tests.forEach(function (test) {
      expect(subject.elementNotReachMinLength.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates SSN correctly", function() {

    var tests = [
      {params: ["123-45-1226"], expected: true},
      {params: ["123-45-1226"], expected: true},
      {params: ["023-15-1326"], expected: true},
      {params: ["123-45-9821"], expected: true},
      {params: ["1-3434-34"], expected: false},
      {params: ["123456a"], expected: false},
      {params: ["1233-45-633"], expected: false},
      {params: ["1234567-343"], expected: false},
      {params: [""], expected: false},
      {params: [null], expected: false}
    ];

    tests.forEach(function (test) {
      expect(subject.elementIsValidSSN.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates age array correctly", function() {

    var tests = [
      {params: ["2, 5, 7"], expected: true},
      {params: ["12, 1, 7, 9"], expected: true},
      {params: ["1, 2"], expected: true},
      {params: ["a, 2"], expected: false},
      {params: [null], expected: false},
      {params: [""], expected: false},
      {params: ["1, a"], expected: false}
    ];

    tests.forEach(function (test) {
      expect(subject.elementIsValidAgeofDependents.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it("validates money amount correctly", function() {

    var tests = [
      {params: ["$27"], expected: true},
      {params: ["$9"], expected: true},
      {params: ["$1,342,334"], expected: true},
      {params: ["$1,342,334.2"], expected: true},
      {params: ["$1,342,334."], expected: true},
      {params: ["$1,342,334.233.3"], expected: false},
      {params: ["$1,342,a"], expected: false},
      {params: ["12"], expected: false},
      {params: [null], expected: false},
      {params: ["$8,888"], expected: true}
    ];

    tests.forEach(function (test) {
      expect(subject.elementIsValidCurrency.apply(subject, test.params)).toBe(test.expected);
    });
  });
});