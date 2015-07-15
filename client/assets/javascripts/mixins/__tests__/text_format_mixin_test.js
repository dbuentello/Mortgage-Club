jest.dontMock('../TextForMatMixin');

describe('text format helper', function() {
  it('commafies number correctly', function() {
    var subject = require('../TextForMatMixin');
    var tests = [
      {params: [31321232.2323], expected: '31,321,232.2323'},
      {params: ['0.2324455'], expected: '0.2324455'},
      {params: ['00999999.1'], expected: '999,999.1'}
    ];

    tests.forEach(function (test) {
      expect(subject.commafy.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('converts number to currency format correctly', function() {
    var subject = require('../TextForMatMixin');
    var tests = [
      {params: [-31321232.2323, '¥'], expected: '-¥31,321,232.23'},
      {params: [2324.455, '$'], expected: '$2,324.46'},
      {params: ['-00999.999', '£'], expected: '-£1,000.00'}
    ];

    tests.forEach(function (test) {
      expect(subject.formatCurrency.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('titleizes string correctly', function() {
    var subject = require('../TextForMatMixin');
    var tests = [
      {params: ['Would you titleize me please?'], expected: 'Would You Titleize Me Please?'},
      {params: ['4zar italiana!'], expected: '4zar Italiana!'},
      {params: [' bl00dy" mary.'], expected: ' Bl00dy" Mary.'}
    ];

    tests.forEach(function (test) {
      expect(subject.titleize.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('converts ISO date to US date correctly', function() {
    var subject = require('../TextForMatMixin');
    var tests = [
      {params: ['2015-12-31'], expected: '12/31/2015'},
      {params: ['2015-02-28T00:00:00.000Z'], expected: '02/28/2015'},
      {params: ['2034-01-01'], expected: '01/01/2034'}
    ];

    tests.forEach(function (test) {
      expect(subject.isoToUsDate.apply(subject, test.params)).toBe(test.expected);
    });
  });

  it('converts US date to ISO date correctly', function() {
    var subject = require('../TextForMatMixin');
    var tests = [
      {params: ['12/31/2015'], expected: '2015-12-31'},
      {params: ['02/02/2022'], expected: '2022-02-02'},
      {params: ['01/01/2034'], expected: '2034-01-01'}
    ];

    tests.forEach(function (test) {
      expect(subject.usToIsoDate.apply(subject, test.params)).toBe(test.expected);
    });
  });

});
