var _ = require('lodash');
var moment = require('moment');

var TextFormatMixin = {
  pluralize: function(n, singular, plural) {
    if (n === 1) {
      return n + ' ' + singular;
    } else {
      return n + ' ' + plural;
    }
  },

  commafy: function(number, decimals) {
    if (typeof number == 'undefined' || number === null) {
      return null;
    }

    var n = parseFloat(number);

    if (typeof decimals != 'undefined') {
      n = n.toFixed(decimals);
    }

    n = (n+'').split('.').map(function(s,i){return i?s:s.replace(/(\d)(?=(?:\d{3})+$)/g,'$1,'); }).join('.');
    return n;
  },

  formatCurrency: function(cashflow, unit) {
    var negative = (cashflow < 0 ? '-' : ''),
        money = Math.abs(cashflow),
        prefix;

    if (unit) {
      prefix = negative + unit;
    } else {
      prefix = negative;
    }

    return prefix + this.commafy(Math.round(money * 100) / 100, 2);
  },

  isoToUsDate: function(dateString) {
    if (!dateString) {
      return dateString;
    }

    return moment(dateString, 'YYYY-MM-DD').format('MM/DD/YYYY');
  },

  usToIsoDate: function(dateString) {
    if (!dateString) {
      return dateString;
    }

    return moment(dateString, 'MM/DD/YYYY').format('YYYY-MM-DD');
  },

  formatTime: function(timeString) {
    return moment(timeString).format('hh:mm A MM/DD/YYYY');
  },

  titleize: function(str) {
    return str.split(/[ _]/).map(function(word) {
      return word.charAt(0).toUpperCase() + word.slice(1);
    }).join(' ');
  }
};

module.exports = TextFormatMixin;
