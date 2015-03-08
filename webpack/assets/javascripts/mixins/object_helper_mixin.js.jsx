

// some recursion here, so leave it out on its own to avoid using `this` keyword in a mixin
var normalize = function (values) {
  var i, vals;

  if (Array.isArray(values)) {
    vals = [];
    for (i = 0; i < values.length; i++) {
      vals.push(normalize(values[i]));
    }
  } else if (typeof values == 'object') {
    vals = {};
    for (i in values) {
      vals[i] = normalize(values[i]);
    }
  } else if (typeof values == 'boolean') {
    return values;
  } else {
    vals = '' + values;
  }

  return vals;
};

var ObjectHelperMixin = {
  // Gets a value that may be buried in a nested chain of properties, while taking into account null/undefined.
  // examples
  // getValue(objA, 'propB.propC.propD')
  // getValue(objA, 'propB.arrayC[0]')
  // getValue(objArray, '[0].propB')
  getValue: function(obj, path) {
    var pList = path.replace(/\[(\w+)\]/g, '.$1').split('.');
    var value = _.reduce(pList, function(memo, propertyName) {
      if (_.isUndefined(memo) || _.isNull(memo)) { return null; }
      return (propertyName === '') ? memo : memo[propertyName];
    }, obj);
    return value;
  },

  setValue: function(obj, path, value) {
      var schema = obj;
      var pList = path.replace(/\[(\w+)\]/g, '.$1').split('.');
      var len = pList.length;
      for (var i = 0; i < len-1; i++) {
        var elem = pList[i];

        if (!schema[elem]) {
          schema[elem] = {};
        }

        schema = schema[elem];
      }

      schema[pList[len-1]] = value;
    },

  normalize: normalize
};

module.exports = ObjectHelperMixin;
