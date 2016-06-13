/**
 * TODO: UNUSED CODE
 */
var UrlMixin = {
  /**
   * Parse query string.
   * ?a=b&c=d to {a: b, c: d}
   * @param {String} (option) queryString
   * @return {Object} query params
   */
  getQueryParams: function(queryString) {
    var query = (queryString || window.location.search).substring(1);

    if (!query) {
      return null;
    }

    return _.chain(query.split('&')).map(function (params) {
      var p = params.split('=');
      return [p[0], decodeURIComponent(p[1])];
    }).object().value();
  }

};

module.exports = UrlMixin;
