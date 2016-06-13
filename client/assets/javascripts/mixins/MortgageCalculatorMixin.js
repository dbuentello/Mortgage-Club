/**
 * Calculate mortgage
 */
var cofiForecast = [0, 0.05, 0.11, 0.16, 0.22, 0.27, 0.33, 0.39, 0.44, 0.50, 0.55, 0.60, 0.63, 0.68, 0.73, 0.78, 0.83, 0.83, 0.88, 0.88, 0.93, 0.98, 0.98, 0.98, 1.08, 1.08, 1.13, 1.18, 1.18, 1.23, 1.28, 1.28, 1.33, 1.38, 1.43, 1.43, 1.48, 1.53, 1.58, 1.63, 1.63, 1.73, 1.73, 1.73, 1.83, 1.83, 1.88, 1.93, 1.93, 1.98, 2.03, 2.03, 2.08, 2.08, 2.08, 2.13, 2.13, 2.18, 2.18, 2.18, 2.18, 2.18, 2.18, 2.18, 2.18, 2.18, 2.13, 2.08, 2.08, 2.08, 2.08, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.03, 2.08, 2.08, 2.08, 2.08, 2.08, 2.08, 2.08, 2.18, 2.18, 2.18, 2.18, 2.18, 2.18, 2.23, 2.23, 2.23, 2.23, 2.23, 2.28, 2.28, 2.28, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.33, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.38, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.43, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.48, 2.43, 2.37, 2.32, 2.26, 2.21, 2.15, 2.09, 2.04, 1.98, 1.93, 1.88, 1.85, 1.80, 1.75, 1.70, 1.65, 1.65, 1.60, 1.60, 1.55, 1.50, 1.50, 1.50, 1.40, 1.40, 1.35, 1.30, 1.30, 1.25, 1.20, 1.20, 1.15, 1.10, 1.05, 1.05, 1.00, 0.95, 0.90, 0.85, 0.85, 0.75, 0.75, 0.75, 0.65, 0.65, 0.60, 0.55, 0.55, 0.50, 0.45, 0.45, 0.40, 0.40, 0.40, 0.35, 0.35, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.35, 0.40, 0.40, 0.40, 0.40, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.40, 0.40, 0.40, 0.40, 0.40, 0.40, 0.40, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.25, 0.25, 0.25, 0.25, 0.25, 0.20, 0.20, 0.20, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.05, 0.11, 0.16, 0.22, 0.27, 0.33, 0.39, 0.44, 0.50, 0.55];
var fixedMonthsMapping = {
  "1/1 ARM": 12,
  "3/1 ARM": 36,
  "5/1 ARM": 60,
  "7/1 ARM": 84
};
var armProducts = ["1/1 ARM", "3/1 ARM", "5/1 ARM", "7/1 ARM"];

var MortgageCalculatorMixin = {
  monthlyPayment: function(amount, rate, numOfPeriods) {
    var ratePerPeriod = rate / 12;
    var numerator = ratePerPeriod * Math.pow((1 + ratePerPeriod), numOfPeriods);
    var denominator = Math.pow((1 + ratePerPeriod), numOfPeriods) - 1;
    var am = amount * (numerator / denominator);
    return Math.round(am * 100) / 100;
  },

  totalInterestPaid: function(amount, rate, expectedMortgageDuration, monthlyPayment, product) {
    var monthlyInterestRate = rate / 12;
    var totalInterest = 0;
    expectedMortgageDuration = expectedMortgageDuration * 12;

    // fixed rate
    if(armProducts.indexOf(product) == -1) {
      for(var i = 1; i <= expectedMortgageDuration; i++) {
        interestPayment = Math.round(amount * monthlyInterestRate * 100) / 100;
        principalPayment = monthlyPayment - interestPayment;
        amount -= principalPayment;
        totalInterest += interestPayment;
      }
    }
    else {
      // ARM
      var numberOfMonthsFixed = fixedMonthsMapping[product];
      var adjustedMonthlyInterestRate = 0;
      for(var i = 1; i <= expectedMortgageDuration; i++) {
        // is n't fixed rate
        if(i > numberOfMonthsFixed) {
          adjustedMonthlyInterestRate = monthlyInterestRate + cofiForecast[i - numberOfMonthsFixed];
        }
        else {
          // fixed rate
          adjustedMonthlyInterestRate = monthlyInterestRate;
        }
        interestPayment = Math.round(amount * adjustedMonthlyInterestRate * 100) / 100;
        principalPayment = monthlyPayment - interestPayment;
        amount -= principalPayment;
        totalInterest += interestPayment;
      }
    }

    return Math.round(totalInterest * 100) / 100;
  },

  totalInterestPaidTaxAdjusted: function(totalInterestPaid, effectiveTaxRate) {
    return totalInterestPaid * (1 - effectiveTaxRate);
  },

  totalFees: function(fees, lenderCredit) {
    fees["Processing fee"]  = fees["Processing fee"] || 0;
    fees["Loan origination fee"] = fees["Loan origination fee"] || 0;
    fees["Appraisal fee"] = fees["Appraisal fee"] || 0;
    fees["Credit report fee"] = fees["Credit report fee"] || 0;
    lenderCredit = lenderCredit || 0;
    var totalFees = fees["Processing fee"] + fees["Loan origination fee"] + fees["Appraisal fee"] + fees["Credit report fee"] + lenderCredit;
    return Math.round(totalFees * 100) / 100;
  },

  upFrontCash: function(downPayment, fees, lenderCredit) {
    var totalFees = this.totalFees(fees, lenderCredit);
    var upFrontCash = downPayment + totalFees;
    return Math.round(upFrontCash * 100) / 100;
  },

  opportunityCostOfUpfrontCash: function(investmentReturnRate, expectedMortgageDuration, upFrontCash) {
    var opportunityCostOfUpfrontCash = (Math.pow((1 + investmentReturnRate), expectedMortgageDuration) - 1) * upFrontCash;
    return Math.round(opportunityCostOfUpfrontCash * 100) / 100;
  },

  opportunityCostOfMonthlyPayment: function(monthlyPayment, investmentReturnRate, expectedMortgageDuration) {
    if(investmentReturnRate == 0) {
      return 0;
    }
    else {
      var opportunityCostOfMonthlyPayment = monthlyPayment * (Math.pow(1 + investmentReturnRate / 12, expectedMortgageDuration * 12) - 1) / (investmentReturnRate / 12) - (monthlyPayment * expectedMortgageDuration * 12);
      return Math.round(opportunityCostOfMonthlyPayment * 100) / 100;
    }
  },

  totalCost: function(quote, effectiveTaxRate, investmentReturnRate, expectedMortgageDuration) {
    var monthlyPayment = this.monthlyPayment(quote["loan_amount"], quote["interest_rate"], quote["period"]);
    var totalInterestPaid =  this.totalInterestPaid(quote["loan_amount"], quote["interest_rate"], expectedMortgageDuration, monthlyPayment, quote["product"]);
    var totalInterestPaidTaxAdjusted = this.totalInterestPaidTaxAdjusted(totalInterestPaid, effectiveTaxRate);
    var upFrontCash = this.upFrontCash(quote["down_payment"], quote["fees"], quote["lender_credit"]);
    var opportunityCostOfUpfrontCash = this.opportunityCostOfUpfrontCash(investmentReturnRate, expectedMortgageDuration, upFrontCash);
    var opportunityCostOfMonthlyPayment = this.opportunityCostOfMonthlyPayment(monthlyPayment, investmentReturnRate, expectedMortgageDuration);

    var totalCost = totalInterestPaidTaxAdjusted + opportunityCostOfUpfrontCash + opportunityCostOfMonthlyPayment;
    var result = {
      'monthlyPayment': monthlyPayment,
      'totalInterestPaid': totalInterestPaid,
      'totalInterestPaidTaxAdjusted': totalInterestPaidTaxAdjusted,
      'upFrontCash': upFrontCash,
      'opportunityCostOfUpfrontCash': opportunityCostOfUpfrontCash,
      'opportunityCostOfMonthlyPayment': opportunityCostOfMonthlyPayment,
      'totalCost': totalCost
    }
    return result;
  }
}
module.exports = MortgageCalculatorMixin;
