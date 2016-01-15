require "rails_helper"
include ActionView::Helpers::NumberHelper

describe Docusign::Templates::UniformResidentialLoanApplication do
  let!(:loan) { FactoryGirl.create(:loan_with_properties) }
  let!(:declaration) { FactoryGirl.create(:declaration, borrower: loan.borrower)}
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
        "loan_amount" => number_with_delimiter(loan.amount),
        "interest_rate" => "#{(loan.interest_rate.to_f * 100).round(3)}",
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
    before(:each) { @service.loan.purpose = "purchase" }

    it "maps right values" do
      property = loan.subject_property
      @service.build_section_2
      expect(@service.params).to include({
        "property_address" => property.address.try(:address),
        "no_of_units" => property.no_of_unit,
        "legal_description" => "See preliminary title",
        "property_title" => "To Be Determined",
        "property_manner" => "To Be Determined in escrow",
        "property_fee_simple" => "x"
      })
    end

    it "marks 'x' to only one property's usage" do
      @service.subject_property.usage = "primary_residence"
      @service.build_section_2

      expect(@service.params["secondary_property"]).not_to eq("x")
      expect(@service.params["investment_property"]).not_to eq("x")
      expect(@service.params["primary_property"]).to eq("x")
    end

    it "marks 'x' to only one property's purpose" do
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
      it "calls #build_refinance_loan" do
        @service.loan.purpose = "refinance"
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_refinance_loan)
        @service.build_section_2
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

  describe "#build_section_4" do
    it "calls #build_employment_info" do
      expect_any_instance_of(
        Docusign::Templates::UniformResidentialLoanApplication
      ).to receive(:build_employment_info).with("borrower", @service.borrower)

      @service.build_section_4
    end

    context "secondary borrower" do
      it "calls #build_employment_info" do
        @service.loan.secondary_borrower = loan.borrower
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_employment_info).at_least(:twice)

        @service.build_section_4
      end
    end
  end

  describe "#build_section_5" do
    it "calls #build_gross_monthly_income" do
      expect_any_instance_of(
        Docusign::Templates::UniformResidentialLoanApplication
      ).to receive(:build_gross_monthly_income).with("borrower", @service.borrower)

      @service.build_section_5
    end

    it "calls #build_housing_expense" do
      @service.primary_property = nil
      expect_any_instance_of(
        Docusign::Templates::UniformResidentialLoanApplication
      ).to receive(:build_housing_expense).with("proposed", @service.subject_property)

      @service.build_section_5
    end

    context "secondary borrower" do
      it "calls #build_gross_monthly_income" do
        @service.loan.secondary_borrower = loan.borrower
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_gross_monthly_income).at_least(:twice)

        @service.build_section_5
      end
    end

    context "primary property" do
      it "calls #build_housing_expense" do
        @service.primary_property = @service.subject_property
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_housing_expense).at_least(:twice)

        @service.build_section_5
      end
    end
  end

  describe "#build_section_7" do
    it "maps right values" do
      total_cost_transactions = (loan.subject_property.purchase_price + loan.estimated_prepaid_items.to_f +
                                  loan.estimated_closing_costs.to_f + loan.pmi_mip_funding_fee.to_f).round(2)
      borrower_cash = (total_cost_transactions - loan.other_credits.to_f - loan.amount).round(2)
      @service.build_section_7
      expect(@service.params).to include({
        "purchase_price" => number_with_delimiter(loan.subject_property.purchase_price.to_f).rjust(9),
        "estimated_prepaid_items" => number_with_delimiter(loan.estimated_prepaid_items).rjust(9),
        "estimated_closing_costs" => number_with_delimiter(loan.estimated_closing_costs).rjust(9),
        "pmi_funding_fee" => number_with_delimiter(loan.pmi_mip_funding_fee).rjust(9),
        "other_credit" => number_with_delimiter(loan.other_credits).rjust(9),
        "loan_amount_exclude_pmi_mip" => number_with_delimiter(loan.amount - loan.pmi_mip_funding_fee.to_f).rjust(9),
        "pmi_mip_funding_fee_financed" => number_with_delimiter(loan.pmi_mip_funding_fee_financed).rjust(9),
        "total_loan_amount" => number_with_delimiter(loan.amount).rjust(9),
        "total_cost_transactions" => number_with_delimiter(total_cost_transactions).rjust(9),
        "borrower_cash" => number_with_delimiter(borrower_cash).rjust(9)
      })
    end

    context "refinance" do
      it "maps right values" do
        @service.loan.purpose = "refinance"
        @service.build_section_7
        expect(@service.params).to include({
          "refinance" => number_with_delimiter(@service.loan.amount)
        })
      end
    end
  end

  describe "#build_section_8" do
    it "calls #build_declaration" do
      expect_any_instance_of(
        Docusign::Templates::UniformResidentialLoanApplication
      ).to receive(:build_declaration).with("borrower", @service.borrower)

      @service.build_section_8
    end

    context "secondary borrower" do
      it "calls #build_gross_monthly_income" do
        @service.loan.secondary_borrower = loan.borrower
        expect_any_instance_of(
          Docusign::Templates::UniformResidentialLoanApplication
        ).to receive(:build_declaration).at_least(:twice)

        @service.build_section_8
      end
    end
  end

  describe "#build_housing_expense" do
    context "subject property" do
      it "maps right values" do
        property = @service.subject_property
        proposed_total_expense = number_with_delimiter((property.mortgage_payment + property.other_financing +
                                              property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                              property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f))
        @service.build_housing_expense("proposed", property)
        expect(@service.params).to include({
          "proposed_first_mortgage" => number_with_delimiter(property.mortgage_payment).rjust(proposed_total_expense.length + 1),
          "proposed_other_financing" => number_with_delimiter(property.other_financing).rjust(proposed_total_expense.length + 1),
          "proposed_hazard_insurance" => number_with_delimiter(property.estimated_hazard_insurance).rjust(proposed_total_expense.length + 1),
          "proposed_estate_taxes" => number_with_delimiter(property.estimated_property_tax).rjust(proposed_total_expense.length + 1),
          "proposed_mortgage_insurance" => number_with_delimiter(property.estimated_mortgage_insurance).rjust(proposed_total_expense.length + 1),
          "proposed_homeowner" => number_with_delimiter(property.hoa_due).rjust(proposed_total_expense.length + 1),
          "proposed_total_expense" => proposed_total_expense
        })
      end
    end

    context "primary property" do
      it "maps right values" do
        property = @service.primary_property
        present_total_expense = number_with_delimiter(property.mortgage_payment + property.other_financing +
                                              property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                              property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f)
        @service.build_housing_expense("present", property)
        expect(@service.params).to include({
          "present_first_mortgage" => number_with_delimiter(property.mortgage_payment).rjust(present_total_expense.length + 1),
          "present_other_financing" => number_with_delimiter(property.other_financing).rjust(present_total_expense.length + 1),
          "present_hazard_insurance" => number_with_delimiter(property.estimated_hazard_insurance).rjust(present_total_expense.length + 1),
          "present_estate_taxes" => number_with_delimiter(property.estimated_property_tax).rjust(present_total_expense.length + 1),
          "present_mortgage_insurance" => number_with_delimiter(property.estimated_mortgage_insurance).rjust(present_total_expense.length + 1),
          "present_homeowner" => number_with_delimiter(property.hoa_due).rjust(present_total_expense.length + 1),
          "present_total_expense" => present_total_expense
        })
      end
    end
  end

  describe "#build_declaration" do
    it "maps right values" do
      @service.build_declaration("borrower", @service.borrower)
      expect(@service.params).to include({
        "declarations_borrower_a_yes" => declaration.outstanding_judgment ? "x" : nil,
        "declarations_borrower_b_yes" => declaration.bankrupt ? "x" : nil,
        "declarations_borrower_c_yes" => declaration.property_foreclosed ? "x" : nil,
        "declarations_borrower_d_yes" => declaration.party_to_lawsuit ? "x" : nil,
        "declarations_borrower_e_yes" => declaration.loan_foreclosure ? "x" : nil,
        "declarations_borrower_f_yes" => declaration.present_delinquent_loan ? "x" : nil,
        "declarations_borrower_g_yes" => declaration.child_support ? "x" : nil,
        "declarations_borrower_h_yes" => declaration.down_payment_borrowed ? "x" : nil,
        "declarations_borrower_i_yes" => declaration.co_maker_or_endorser ? "x" : nil,
        "declarations_borrower_j_yes" => declaration.us_citizen ? "x" : nil,
        "declarations_borrower_k_yes" => declaration.permanent_resident_alien ? "x" : nil,
        "declarations_borrower_m_yes" => declaration.ownership_interest ? "x" : nil,
        "declarations_borrower_a_no" => declaration.outstanding_judgment ? nil : "x",
        "declarations_borrower_b_no" => declaration.bankrupt ? nil : "x",
        "declarations_borrower_c_no" => declaration.property_foreclosed ? nil : "x",
        "declarations_borrower_d_no" => declaration.party_to_lawsuit ? nil : "x",
        "declarations_borrower_e_no" => declaration.loan_foreclosure ? nil : "x",
        "declarations_borrower_f_no" => declaration.present_delinquent_loan ? nil : "x",
        "declarations_borrower_g_no" => declaration.child_support ? nil : "x",
        "declarations_borrower_h_no" => declaration.down_payment_borrowed ? nil : "x",
        "declarations_borrower_i_no" => declaration.co_maker_or_endorser ? nil : "x",
        "declarations_borrower_j_no" => declaration.us_citizen ? nil : "x",
        "declarations_borrower_k_no" => declaration.permanent_resident_alien ? nil : "x",
        "declarations_borrower_m_no" => declaration.ownership_interest ? nil : "x",
        "declarations_borrower_m_1"  => declaration.type_of_property,
        "declarations_borrower_m_2"  => declaration.title_of_property
      })
    end
  end

  describe "#build_gross_monthly_income" do
    it "maps right values" do
      borrower = @service.borrower
      @service.build_gross_monthly_income("borrower", borrower)
      borrower_total_income = number_with_delimiter(borrower.total_income.to_f)

      expect(@service.params).to include({
        "borrower_base_income" => number_with_delimiter(borrower.current_salary).rjust(borrower_total_income.length + 1),
        "borrower_overtime" => number_with_delimiter(borrower.gross_overtime.to_f).rjust(borrower_total_income.length + 1),
        "borrower_bonuses" => number_with_delimiter(borrower.gross_bonus.to_f).rjust(borrower_total_income.length + 1),
        "borrower_commissions" => number_with_delimiter(borrower.gross_commission.to_f).rjust(borrower_total_income.length + 1),
        "borrower_total_income" => borrower_total_income
      })
    end
  end

  describe "#build_employment_info" do
    it "maps right values" do
      current_employment = @service.borrower.current_employment
      @service.build_employment_info("borrower", @service.borrower)

      expect(@service.params).to include({
        "borrower_yrs_job" => current_employment.duration,
        "borrower_yrs_employed" => current_employment.duration,
        "borrower_name_employer_1" => current_employment.employer_name,
        "borrower_street_employer_1" => current_employment.address.street_address,
        "borrower_city_and_state_employer_1" => "#{current_employment.address.city}, #{current_employment.address.state} #{current_employment.address.zip}",
        "borrower_position_1" => current_employment.job_title,
        "borrower_business_phone_1" => current_employment.employer_contact_number
      })
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
        "borrower_dob" => @service.borrower.dob.strftime('%D'),
        "borrower_yrs_school" => @service.borrower.years_in_school,
        "borrower_married" => "x",
        "borrower_dependents_no" => @service.borrower.dependent_count,
        "borrower_dependents_ages" => @service.borrower.dependent_ages.join(", "),
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

  describe "#build_refinance_loan" do
    it "maps right values relating to refinance" do
      property = @service.loan.subject_property
      purpose_of_refinance = (@service.loan.amount > property.total_liability_balance) ? "Cash out" : "Rate and term"
      @service.build_refinance_loan
      expect(@service.params).to include({
        "loan_purpose_refinance" => "x",
        "refinance_year_acquired" => property.original_purchase_year,
        "refinance_original_cost" => number_with_delimiter(property.original_purchase_price.to_f),
        "refinance_amount_existing_liens" => number_with_delimiter(property.refinance_amount),
        "purpose_of_refinance" => purpose_of_refinance,
        "year_built" => property.year_built
      })
    end
  end
end
