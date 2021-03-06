/**
 * Format library helps dev format text as currency, percentage, ...
 */
var _ = require('lodash');
var moment = require('moment');

function splice(value, index, insert) {
  // Splices 'insert' into the 'index' position on 'value' if value has at least 'index' items
  return value.slice(0, index) + (value.length > index ? insert +  value.slice(index) : '');
}

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

    n = (n+'').split('.').map(function(s,i){
      return i ? s : s.replace(/(\d)(?=(?:\d{3})+$)/g,'$1,');
    }).join('.');

    return n;
  },

  currencyToNumber: function(val) {
    if (!val) {
      return val;
    }

    return val.replace('$', '').replace(')', '').replace('(', '-').replace(/\,/g, '');
  },
  percentToNumber: function(val) {
    if (!val) {
      return val;
    }

    return val.replace('%', '').replace(/\,/g, '');
  },

  formatCurrency: function(cashflow, decimals, unit) {
    var negative, money, prefix;
    var decimal = 2;

    if(cashflow == 0){
      if (unit) {
        return unit + "0";
      } else {
         return "$0";
      }
    }

    if(!decimals){
      if(!isNaN(parseInt(decimals))){
        decimal = parseInt(decimals);
      }
    }

    if (!cashflow) {
      return cashflow;
    }

    if (typeof cashflow === 'string' || cashflow instanceof String) {
      cashflow = cashflow.replace(/[^(\d|.).-]/g, '');
    }

    cashflow = Math.ceil(cashflow * 100) / 100;
    negative = (cashflow < 0 ? '(' : '');
    money = Math.abs(cashflow);
    prefix;

    if (unit) {
      prefix = negative + unit;
    } else {
      prefix = negative + '$';
    }

    suffix = negative == '(' ? ')' : '';

    return prefix + this.commafy(money, decimal) + suffix;
  },

  /**
   * converts UTC time in ISO format to a date string in regular US format.
   * @param  {String} time   e.g. '2015-03-24T03:04:43.994Z'
   * @return {String}        e.g. '03/23/2015'
   */
  isoToUsDate: function(time) {
    if (!time) {
      return time;
    }

    return moment(time, [moment.ISO_8601, 'YYYY-MM-DD']).format('MM/DD/YYYY');
  },

  /**
   * converts a date string in US format to UTC time in ISO 8601 format
   * @param  {String} dateString e.g. '03/24/2015'
   * @return {String}            e.g. '2015-03-24T07:00:00+00:00'
   */
  usToIsoDate: function(dateString) {
    if (!dateString) {
      return dateString;
    }

    return moment(dateString, 'MM/DD/YYYY').utc().format();
  },

  formatTime: function(timeString) {
    return moment(timeString).format('hh:mm A MM/DD/YYYY');
  },

  formatTimeCustom: function(timeString, format) {
    return moment(timeString).format(format);
  },

  titleize: function(str) {
    return str.split(/[ _]/).map(function(word) {
      return word.charAt(0).toUpperCase() + word.slice(1);
    }).join(' ');
  },

  formatInteger: function(val) {
    if (!val) { return; }
    return ('' + val).replace(/\D/g, '');
  },

  formatNumber: function(val) {
    if (!val) { return; }
    return ('' + val).replace(/[^0-9\.]/g, '');
  },

  formatPercent: function(value) {
    var money;
    var decimal = 3;

    if (!value) {
      return value;
    }

    if (typeof value === 'string' || value instanceof String) {
      value = value.replace(/[^(\d|.).-]/g, '');
    }

    value = Math.ceil(value * 1000) / 1000;
    money = Math.abs(value);


    return this.commafy(money, decimal) + "%";
  },

  formatSSN: function(val) {
    if (!val) { return; }
    val = val.replace(/\D/g, '');
    return splice(splice(val, 3, '-'), 6, '-').slice(0, 11);
  },

  formatYear: function(s) {
    if(!s) { return; }
    var currentYear = (new Date(Date.now()).getFullYear())*1;
    s = ("" + s).replace(/\D/g, '');

    if(currentYear < parseInt(s)) {
      return currentYear.toString();
    }

    if(s.length === 4 && parseInt(s) < 1900) {
      return currentYear.toString();
    }
    return s;
  },

  formatPhoneNumber: function(val) {
    if (!val) { return; }
    val = val.replace(/\D/g, '');
    return ('(' + splice(splice(val, 3, ') '), 8, '-').slice(0, 13));
  }
};

module.exports = TextFormatMixin;
