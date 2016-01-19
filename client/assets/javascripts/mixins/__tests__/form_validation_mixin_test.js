jest.dontMock("../FormValidationMixin");

describe('text format helper', function() {
  var subject= require("../FormValidationMixin");

  it('validate email correctly', function() {

    var tests = [
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
});