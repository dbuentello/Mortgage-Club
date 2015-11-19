require "rails_helper"

describe Docusign::Templates::UniformResidentialLoanApplication do
  let!(:loan) { FactoryGirl.create(:loan_with_properties) }
  before(:each) do
    @service = Docusign::Templates::UniformResidentialLoanApplication.new(loan)
  end

  describe "#build_part_1" do
    it "calls #build_loan_type" do
      expect_any_instance_of(Docusign::Templates::UniformResidentialLoanApplication).to receive(:build_loan_type)
      @service.build_part_1
    end

    it "maps right values" do
      @service.build_part_1
      expect(@service.params).to include({
        "loan_amount" => Money.new(loan.amount * 100).format,
        "interest_rate" => "#{(loan.interest_rate.to_f * 100).round(3)}%",
        "no_of_month" => loan.num_of_months
      })
    end

    it "adds 'x' to only one amortization type" do
      @service.loan.amortization_type = "5/1 ARM"
      @service.build_part_1
      expect(@service.params["amortization_fixed_rate"]).not_to eq("x")
      expect(@service.params["amortization_arm"]).to eq("x")
    end

    context "fixed rate" do
      it "adds 'x' to param's amortization" do
        @service.loan.amortization_type = "30 year fixed"
        @service.build_part_1
        expect(@service.params["amortization_fixed_rate"]).to eq("x")
      end
    end

    context "arm" do
      it "adds 'x' to param's amortization" do
        @service.loan.amortization_type = "5/1 ARM"
        @service.build_part_1
        expect(@service.params["amortization_arm"]).to eq("x")
      end
    end
  end

  describe "#build_loan_type" do
    it "adds 'x' to only one mortgage applied type" do
      @service.loan.loan_type = "Conventional"
      @service.build_part_1
      expect(@service.params['mortgage_applied_fha']).not_to eq("x")
      expect(@service.params['mortgage_applied_usda']).not_to eq("x")
      expect(@service.params['mortgage_applied_va']).not_to eq("x")
      expect(@service.params['mortgage_applied_other']).not_to eq("x")
      expect(@service.params['mortgage_applied_conventional']).to eq("x")
    end

    context "Conventional" do
      it "adds 'x' to param's mortgage applied" do
        @service.loan.loan_type = "Conventional"
        @service.build_part_1
        expect(@service.params['mortgage_applied_conventional']).to eq("x")
      end
    end

    context "FHA" do
      it "adds 'x' to param's mortgage applied" do
        @service.loan.loan_type = "FHA"
        @service.build_part_1
        expect(@service.params['mortgage_applied_fha']).to eq("x")
      end
    end

    context "USDA" do
      it "adds 'x' to param's mortgage applied" do
        @service.loan.loan_type = "USDA"
        @service.build_part_1
        expect(@service.params['mortgage_applied_usda']).to eq("x")
      end
    end

    context "VA" do
      it "adds 'x' to param's mortgage applied" do
        @service.loan.loan_type = "VA"
        @service.build_part_1
        expect(@service.params['mortgage_applied_va']).to eq("x")
      end
    end

    context "Other" do
      it "adds 'x' to param's mortgage applied" do
        @service.loan.loan_type = "LoremIpsum"
        @service.build_part_1
        expect(@service.params['mortgage_applied_other']).to eq("x")
      end
    end
  end
end
