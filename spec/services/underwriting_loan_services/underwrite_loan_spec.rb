require "rails_helper"

describe UnderwritingLoanServices::UnderwriteLoan do
  let!(:loan) { FactoryGirl.create(:loan) }
  let!(:property) { FactoryGirl.create(:property_with_address, is_subject: true, loan: loan) }
  let!(:borrower) { FactoryGirl.create(:borrower, loan: loan) }

  before(:each) do
    @service = UnderwritingLoanServices::UnderwriteLoan.new(loan)
  end

  describe "#verify_property" do
    context "invalid" do
      it "adds an error message" do
        @service.property = nil
        @service.verify_property

        expect(@service.error_messages).to include("Sorry, your subject property does not exist.")
      end
    end
  end

  describe "#verify_property_eligibility" do
    context "invalid address" do
      it "adds an error message" do
        @service.address = nil
        @service.verify_property_eligibility

        expect(@service.error_messages).to include("Sorry, your property must have an address.")
      end
    end

    context "invalid state" do
      it "adds an error message" do
        @service.address.state = "NY"
        @service.verify_property_eligibility

        expect(@service.error_messages).to include("Sorry, we only lend in CA at this time. We'll contact you once we're ready to lend in.")
      end
    end

    context "invalid property type" do
      it "adds an error message" do
        @service.property.property_type = nil
        @service.verify_property_eligibility

        expect(@service.error_messages).to include("Sorry, your subject property is not eligible. We only offer loan programs for residential 1-4 units at this time.")
      end
    end
  end

  describe "#verify_credit_score" do
    context "less than 620" do
      it "adds an error message" do
        allow_any_instance_of(Borrower).to receive(:credit_score).and_return(100)
        @service.verify_credit_score

        expect(@service.error_messages).to include("Sorry, your credit score is below the minimum required to obtain a mortgage.")
      end
    end
  end

  describe "#verify_debt_to_income_and_ratio" do
    context "debt_to_income > 0.5" do
      it "adds an error message" do
        allow(UnderwritingLoanServices::CalculateDebtToIncome).to receive(:call).and_return(1)
        @service.verify_debt_to_income_and_ratio

        expect(@service.error_messages).to include("Your debt-to-income ratio is too high. We can't find any loan programs for you.")
      end
    end

    context "housing expense ratio > 0.28" do
      it "adds an error message" do
        allow(UnderwritingLoanServices::CalculateHousingExpenseRatio).to receive(:call).and_return(1)
        @service.verify_debt_to_income_and_ratio

        expect(@service.error_messages).to include("Your housing expense is currently too high. We can't find any loan programs for you.")
      end
    end
  end

  describe "#valid_loan?" do
    context "valid loan" do
      it "returns true" do
        @service.error_messages = []
        expect(@service.valid_loan?).to be_truthy
      end
    end

    context "invalid loan" do
      it "returns false" do
        @service.error_messages = ["Error message"]
        expect(@service.valid_loan?).to be_falsey
      end
    end
  end

  describe "#call" do
    context "valid loan" do
      before(:each) do
        @service.address.state = "CA"
        allow_any_instance_of(Borrower).to receive(:credit_score).and_return(999)
        allow(UnderwritingLoanServices::CalculateDebtToIncome).to receive(:call).and_return(0.5)
        allow(UnderwritingLoanServices::CalculateHousingExpenseRatio).to receive(:call).and_return(0.26)
      end

      it "returns true" do
        expect(@service.call).to be_truthy
      end
    end

    context "invalid loan" do
      # it "returns false" do
      #   expect(@service.call).to be_falsey
      # end
    end
  end
end
