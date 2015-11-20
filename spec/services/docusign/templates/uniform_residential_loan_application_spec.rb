require "rails_helper"

describe Docusign::Templates::UniformResidentialLoanApplication do
  let!(:loan) { FactoryGirl.create(:loan_with_properties) }
  before(:each) do
    @service = Docusign::Templates::UniformResidentialLoanApplication.new(loan)
  end

  describe "#build_section_1" do
    it "calls #build_loan_type" do
      expect_any_instance_of(Docusign::Templates::UniformResidentialLoanApplication).to receive(:build_loan_type)
      @service.build_section_1
    end

    it "maps right values" do
      @service.build_section_1
      expect(@service.params).to include({
        "loan_amount" => Money.new(loan.amount * 100).format,
        "interest_rate" => "#{(loan.interest_rate.to_f * 100).round(3)}%",
        "no_of_month" => loan.num_of_months
      })
    end

    it "marks 'x' to only one amortization type" do
      @service.loan.amortization_type = "5/1 ARM"
      @service.build_section_1
      expect(@service.params["amortization_fixed_rate"]).not_to eq("x")
      expect(@service.params["amortization_arm"]).to eq("x")
    end

    context "fixed rate" do
      it "marks 'x' to param's amortization" do
        @service.loan.amortization_type = "30 year fixed"
        @service.build_section_1
        expect(@service.params["amortization_fixed_rate"]).to eq("x")
      end
    end

    context "arm" do
      it "marks 'x' to param's amortization" do
        @service.loan.amortization_type = "5/1 ARM"
        @service.build_section_1
        expect(@service.params["amortization_arm"]).to eq("x")
      end
    end
  end

  describe "#build_section_2" do
    before(:each) { @property = loan.primary_property }

    it "maps right values" do
      @service.build_section_2
      expect(@service.params).to include({
        "property_address" => @property.address.try(:address),
        "no_of_units" => @property.no_of_unit,
        "legal_description" => "See preliminary title",
        "property_title" => "To Be Determined",
        "property_manner" => "To Be Determined in escrow",
        "property_fee_simple" => "x"
      })
    end

    it "marks 'x' to only one property's usage" do
      @service.property.usage = "primary_residence"
      @service.build_section_2

      expect(@service.params["secondary_property"]).not_to eq("x")
      expect(@service.params["investment_property"]).not_to eq("x")
      expect(@service.params["primary_property"]).to eq("x")
    end

    it "marks 'x' to only one property's purpose" do
      @service.loan.purpose = "purchase"
      @service.build_section_2

      expect(@service.params["loan_purpose_refinance"]).not_to eq("x")
      expect(@service.params["loan_purpose_purchase"]).to eq("x")
    end

    context "purchase" do
      it "marks 'x' to purpose purchase" do
        @service.loan.purpose = "purchase"
        @service.build_section_2

        expect(@service.params["loan_purpose_purchase"]).to eq("x")
      end
    end

    context "refinance" do
      it "maps right values relating to refinance" do
        @service.loan.purpose = "refinance"
        @service.build_section_2
        expect(@service.params).to include({
          "loan_purpose_refinance" => "x",
          "refinance_year_acquired" => @property.original_purchase_year,
          "refinance_original_cost" => @property.original_purchase_price,
          "refinance_amount_existing_liens" => @property.refinance_amount
        })
      end
    end
  end

  describe "#build_section_3" do
    it "calls #build_borrower_info" do
      expect_any_instance_of(
        Docusign::Templates::UniformResidentialLoanApplication
      ).to receive(:build_borrower_info).with("borrower", @service.borrower)

      @service.build_section_3
    end

    context "secondary borrower" do
      it "calls #build_borrower_info" do
        @service.loan.secondary_borrower = loan.borrower
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_borrower_info).at_least(:twice)

        @service.build_section_3
      end
    end
  end

  describe "#build_borrower_info" do
    it "maps right values" do
      @service.borrower.marital_status = "married"
      @service.build_borrower_info("borrower", @service.borrower)

      expect(@service.params).to include({
        "borrower_name" => @service.borrower.full_name,
        "borrower_social_security_number" => @service.borrower.ssn,
        "borrower_home_phone" => @service.borrower.phone,
        "borrower_dob" => @service.borrower.dob,
        "borrower_yrs_school" => @service.borrower.years_in_school,
        "borrower_married" => "x",
        "borrower_dependents_no" => @service.borrower.dependent_count,
        "borrower_dependents_ages" => @service.borrower.dependent_ages,
        "borrower_present_address" => @service.borrower.display_current_address,
        "borrower_present_address_no_yrs" => @service.borrower.current_address.try(:years_at_address),
        "borrower_former_address" => @service.borrower.display_previous_address,
        "borrower_former_address_no_yrs" => @service.borrower.previous_address.try(:years_at_address)
      })
    end
  end

  describe "#build_loan_type" do
    it "marks 'x' to only one mortgage applied type" do
      @service.loan.loan_type = "Conventional"
      @service.build_section_1
      expect(@service.params['mortgage_applied_fha']).not_to eq("x")
      expect(@service.params['mortgage_applied_usda']).not_to eq("x")
      expect(@service.params['mortgage_applied_va']).not_to eq("x")
      expect(@service.params['mortgage_applied_other']).not_to eq("x")
      expect(@service.params['mortgage_applied_conventional']).to eq("x")
    end

    context "Conventional" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "Conventional"
        @service.build_section_1
        expect(@service.params['mortgage_applied_conventional']).to eq("x")
      end
    end

    context "FHA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "FHA"
        @service.build_section_1
        expect(@service.params['mortgage_applied_fha']).to eq("x")
      end
    end

    context "USDA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "USDA"
        @service.build_section_1
        expect(@service.params['mortgage_applied_usda']).to eq("x")
      end
    end

    context "VA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "VA"
        @service.build_section_1
        expect(@service.params['mortgage_applied_va']).to eq("x")
      end
    end

    context "Other" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "LoremIpsum"
        @service.build_section_1
        expect(@service.params['mortgage_applied_other']).to eq("x")
      end
    end
  end
end
