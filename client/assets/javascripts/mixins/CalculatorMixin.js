var Finance = require('financejs');
var finance = new Finance();

var CalculatorMixin = {
  amortization: function(interest_rate, duration) {
    console.dir(finance.AM(20000, 7.5, 5, 0));
  },
}
module.exports = CalculatorMixin;