global._ = require('lodash');
jest.dontMock('../ObjectHelperMixin');

describe('object helper', function() {
  it('mutates values in object with string reference correctly', function() {
    var helper = require('../ObjectHelperMixin');
    var flexport = {
      id: 1,
      name: 'Ryan',
      team: [{
        id: 2,
        name: 'Amos',
        team: [
          {id: 3, name: 'Evie'},
          {id: 4, name: 'Andy'},
          {id: 5, name: 'Tuan'}
        ]
      }, {
        id: 6,
        name: 'AC',
        team: [
          {id: 7, name: 'Hursh'}
        ]
      }]
    };

    helper.setValue(flexport, 'name', 'Ryan Peterson');
    expect(flexport.name).toEqual('Ryan Peterson');

    helper.setValue(flexport, 'team[1].name', 'Anthony Chen');
    expect(flexport.team[1].name).toEqual('Anthony Chen');

    helper.setValue(flexport, 'team[0].team[2].name', 'Andy Ledvina');
    expect(flexport.team[0].team[2].name).toEqual('Andy Ledvina');
  });

  it ('normalizes arrays (converts things to string) correctly', function () {
    var helper = require('../ObjectHelperMixin');
    var randomList = ['1', 3, 'random', true, [{id: 1, name: 'One'}]];
    var flexport = [
      {id: 1, name: 'Hursh'},
      {id: 2, name: 'AC'}
    ];

    flexport = helper.normalize(flexport);

    expect(flexport).toEqual([
      {id: '1', name: 'Hursh'},
      {id: '2', name: 'AC'}
    ]);

    randomList = helper.normalize(randomList);
    expect(randomList).toEqual(['1', '3', 'random', true, [{id: '1', name: 'One'}]]);

  });

  it ('reads nested object properties correctly', function() {
    var helper = require('../ObjectHelperMixin');

    var parent = {
      nestA: {
        nestB: {
          c: 'c'
        }
      }
    };
    expect(parent.nestA.nestB.c).toEqual('c');
  });

  it ('reads nested object properties with undefined/null values, and returns null', function() {
    var helper = require('../ObjectHelperMixin');

    var parent = {
      nestA: {
        nestB: {
          c: 'c'
        }
      }
    };

    expect(helper.getValue(parent, 'nestA.nestC.c')).toEqual(null);
  });

  it ('accesses nested array indexers correctly', function () {
    var helper = require('../ObjectHelperMixin');

    var flexport = {
      id: 1,
      name: 'Ryan',
      team: [{
        id: 2,
        name: 'Amos',
        team: [
          {id: 3, name: 'Evie'},
          {id: 4, name: 'Andy'},
          {id: 5, name: 'Tuan'}
        ]
      }, {
        id: 6,
        name: 'AC',
        team: [
          {id: 7, name: 'Hursh'}
        ]
      }]
    };

    expect(flexport.team[0].id).toEqual(2);
  });

  it ('accesses nested array indexers correctly', function () {
    var helper = require('../ObjectHelperMixin');

    var flexport = [{
      id: 1,
      name: 'Ryan',
      team: [{
        id: 2,
        name: 'Amos',
        team: [
          {id: 3, name: 'Evie'},
          {id: 4, name: 'Andy'},
          {id: 5, name: 'Tuan'}
        ]
      }, {
        id: 6,
        name: 'AC',
        team: [
          {id: 7, name: 'Hursh'}
        ]
      }]
    }];

    expect(flexport[0].team[0].id).toEqual(2);
  });

  it ('accesses nested array indexers with undefined/null values, and returns null', function() {
    var helper = require('../ObjectHelperMixin');

    var flexport = {
      id: 1,
      name: 'Ryan',
      team: [{
        id: 2,
        name: 'Amos',
        team: [
          {id: 3, name: 'Evie'},
          {id: 4, name: 'Andy'},
          {id: 5, name: 'Tuan'}
        ]
      }, {
        id: 6,
        name: 'AC',
        team: [
          {id: 7, name: 'Hursh'}
        ]
      }]
    };

    expect(helper.getValue(flexport, 'fake-team[0].id')).toEqual(null);
  });

  it ('returns null on bad index', function() {
    var helper = require('../ObjectHelperMixin');

    var flexport = {
      id: 1,
      name: 'Ryan',
      team: [{
        id: 2,
        name: 'Amos',
        team: [
          {id: 3, name: 'Evie'},
          {id: 4, name: 'Andy'},
          {id: 5, name: 'Tuan'}
        ]
      }, {
        id: 6,
        name: 'AC',
        team: [
          {id: 7, name: 'Hursh'}
        ]
      }]
    };

    expect(helper.getValue(flexport, 'team[2].id')).toEqual(null);
    expect(helper.getValue(null, 'team[2].id.fdsjlsfda.ljfdslkjflas')).toEqual(null);
  });
});
