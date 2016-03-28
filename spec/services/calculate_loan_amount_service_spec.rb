require "rails_helper"

describe CalculateLoanAmountService do
  let(:loan) { FactoryGirl.create(:loan_with_properties, down_payment: 50_000) }

  describe ".calculate_loan_amount_for_refinance_loan" do
    context "with mortgage payment" do
      let!(:liability) { FactoryGirl.create(:liability, property: loan.subject_property, account_type: "Mortgage") }

      it "returns balance of mortgage payment" do
        expect(described_class.calculate_loan_amount_for_refinance_loan(loan)).to eq(liability.balance)
      end
    end

    context "without mortgage payment" do
      it "returns 75% of subject property's market price" do
        amount = 0.75 * loan.subject_property.market_price.to_f
        expect(described_class.calculate_loan_amount_for_refinance_loan(loan)). to eq(amount)
      end
    end
  end

  describe ".calculate_loan_amount_for_purchase_loan" do
    context "with down payment" do
      it "returns a result of purchase price minus down payment" do
        amount = loan.subject_property.purchase_price.to_f - loan.down_payment
        expect(described_class.calculate_loan_amount_for_purchase_loan(loan)).to eq(amount)
      end
    end

    context "without down payment" do
      it "returns 75% of subject property's purchase price" do
        loan.down_payment = nil
        amount = 0.75 * loan.subject_property.purchase_price.to_f
        expect(described_class.calculate_loan_amount_for_purchase_loan(loan)).to eq(amount)
      end
    end
  end

  describe ".call" do
    context "with refinance loan" do
      before(:each) { loan.refinance! }

      it "calls calculate_loan_amount_for_refinance_loan" do
        expect(described_class).to receive(:calculate_loan_amount_for_refinance_loan).with(loan)

        described_class.call(loan)
      end

      it "returns amount which is the same as result of calculate_loan_amount_for_refinance_loan" do
        amount = described_class.calculate_loan_amount_for_refinance_loan(loan)
        expect(described_class.call(loan)).to eq(amount)
      end
    end

    context "with purchase loan" do
      before(:each) { loan.purchase! }

      it "calls calculate_loan_amount_for_purchase_loan" do
        expect(described_class).to receive(:calculate_loan_amount_for_purchase_loan).with(loan)

        described_class.call(loan)
      end

      it "returns amount which is the same as result of calculate_loan_amount_for_purchase_loan" do
        amount = described_class.calculate_loan_amount_for_purchase_loan(loan)
        expect(described_class.call(loan)).to eq(amount)
      end
    end
  end
end
