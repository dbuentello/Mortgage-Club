var MortgageCalculatorMixin = {
  monthlyPayment: function(amount, rate, numOfPeriods) {
    var ratePerPeriod = rate / 12;
    var numerator = ratePerPeriod * Math.pow((1 + ratePerPeriod), numOfPeriods);
    var denominator = Math.pow((1 + ratePerPeriod), numOfPeriods) - 1;
    var am = amount * (numerator / denominator);
    return Math.round(am * 100) / 100;
  },

  totalInterestPaid: function(amount, rate, numOfPeriods, monthlyPayment) {
    var monthlyInterestRate = rate / 12;
    var totalInterest = 0;
    for(var i = 1; i <= numOfPeriods; i++) {
      interestPayment = Math.round(amount * monthlyInterestRate * 100) / 100;
      principalPayment = monthlyPayment - interestPayment;
      amount -= principalPayment;
      totalInterest += interestPayment;
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
    var totalInterestPaid =  this.totalInterestPaid(quote["loan_amount"], quote["interest_rate"], quote["period"], monthlyPayment);
    var totalInterestPaidTaxAdjusted = this.totalInterestPaidTaxAdjusted(totalInterestPaid, effectiveTaxRate);
    var upFrontCash = this.upFrontCash(quote["down_payment"], quote["fees"], quote["lender_credit"]);
    var opportunityCostOfUpfrontCash = this.opportunityCostOfUpfrontCash(investmentReturnRate, expectedMortgageDuration, upFrontCash);
    var opportunityCostOfMonthlyPayment = this.opportunityCostOfMonthlyPayment(monthlyPayment, investmentReturnRate, expectedMortgageDuration);

    return totalInterestPaidTaxAdjusted + opportunityCostOfUpfrontCash + opportunityCostOfMonthlyPayment;
  }
}
module.exports = MortgageCalculatorMixin;
