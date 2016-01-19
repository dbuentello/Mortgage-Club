jest.dontMock('../FormValidationMixin');

describe('text format helper', function() {
  var subject= require("../FormValidationMixin");
  it('validate email correctly', function(){

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
    {params: ["dj*exampexamplecom"], expected: false},

    ];
    tests.forEach(function (test) {
      expect(subject.elementIsEmail.apply(subject, test.params)).toBe(test.expected);
    });
  });
});