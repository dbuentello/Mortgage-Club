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
        loan_amount: number_with_delimiter(loan.amount),
        interest_rate: "#{"%.3f" % (loan.interest_rate.to_f * 100)}",
        number_of_month: loan.num_of_months
      })
    end

    it "marks 'x' to only one amortization type" do
      @service.loan.amortization_type = "5/1 ARM"
      @service.build_section_1
      expect(@service.params[:arm_fixed_rate]).not_to eq("Yes")
      expect(@service.params[:arm_type]).to eq("Yes")
    end

    context "fixed rate" do
      it "marks 'x' to param's amortization" do
        @service.loan.amortization_type = "30 year fixed"
        @service.build_section_1
        expect(@service.params[:arm_fixed_rate]).to eq("Yes")
      end
    end

    context "arm" do
      it "marks 'x' to param's amortization" do
        @service.loan.amortization_type = "5/1 ARM"
        @service.build_section_1
        expect(@service.params[:arm_type]).to eq("Yes")
      end
    end
  end

  describe "#build_section_2" do
    before(:each) { @service.loan.purpose = "purchase" }

    it "maps right values" do
      property = loan.subject_property
      @service.build_section_2
      expect(@service.params).to include({
        subject_property_address: property.address.try(:address),
        no_units:  property.no_of_unit,
        subject_property_description: "See preliminary title",
        property_title: "To be determined",
        property_manner: "To be determined in escrow",
        fee_simple: "Yes"
      })
    end

    it "marks 'x' to only one property's usage" do
      @service.subject_property.usage = "primary_residence"
      @service.build_section_2

      expect(@service.params[:secondary_residence]).not_to eq("Yes")
      expect(@service.params[:investment]).not_to eq("Yes")
      expect(@service.params[:primary_residence]).to eq("Yes")
    end

    it "marks 'x' to only one property's purpose" do
      @service.build_section_2

      expect(@service.params[:purpose_refinance]).not_to eq("Yes")
      expect(@service.params[:purpose_purchase]).to eq("Yes")
    end

    context "purchase" do
      it "marks 'x' to purpose purchase" do
        @service.loan.purpose = "purchase"
        @service.build_section_2

        expect(@service.params[:purpose_purchase]).to eq("Yes")
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
        purchase_price: "%.2f" % loan.subject_property.purchase_price.to_f,
        prepaid_items: "%.2f" % loan.estimated_prepaid_items,
        closing_costs: "%.2f" % loan.estimated_closing_costs,
        pmi_mip: "%.2f" % loan.pmi_mip_funding_fee,
        other_credits: "%.2f" % loan.other_credits,
        loan_amount_exclude_pmi: "%.2f" % (loan.amount - loan.pmi_mip_funding_fee.to_f),
        pmi_mip_financed: "%.2f" % loan.pmi_mip_funding_fee_financed,
        loan_amount_m_n: "%.2f" % loan.amount,
        borrower_cash: "%.2f" %(borrower_cash),
        total_costs: "%.2f" %(total_cost_transactions)
      })
    end

    context "refinance" do
      it "maps right values" do
        @service.loan.purpose = "refinance"
        @service.build_section_7
        expect(@service.params).to include({
          refinance: "%.2f" % @service.loan.amount
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
        proposed_total_expense = property.mortgage_payment + property.other_financing +
                                 property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                 property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f
        @service.build_housing_expense("proposed", property)
        expect(@service.params).to include({
          proposed_mortgage: "%.2f" % property.mortgage_payment,
          proposed_other_financing: "%.2f" % property.other_financing,
          proposed_hazard_insurance: "%.2f" % property.estimated_hazard_insurance,
          proposed_real_estate_taxes: "%.2f" % property.estimated_property_tax,
          proposed_mortgage_insurance: "%.2f" % property.estimated_mortgage_insurance,
          proposed_homeowner: "%.2f" % property.hoa_due,
          proposed_total: "%.2f" %(proposed_total_expense)
        })
      end
    end

    context "primary property" do
      it "maps right values" do
        property = @service.primary_property
        present_total_expense = property.mortgage_payment + property.other_financing +
                                property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f
        @service.build_housing_expense("present", property)
        expect(@service.params).to include({
          present_mortgage: "%.2f" % property.mortgage_payment,
          present_other_financing: "%.2f" % property.other_financing,
          present_hazard_insurance: "%.2f" % property.estimated_hazard_insurance,
          present_real_estate_taxes: "%.2f" % property.estimated_property_tax,
          present_mortgage_insurance: "%.2f" % property.estimated_mortgage_insurance,
          present_homeowner: "%.2f" % property.hoa_due,
          present_total: "%.2f" %(present_total_expense)
        })
      end
    end
  end

  describe "#build_declaration" do
    it "maps right values" do
      @service.build_declaration("borrower", @service.borrower)
      expect(@service.params).to include({
        borrower_a_no: declaration.outstanding_judgment ? "Off" : "Yes",
        borrower_a_yes: declaration.outstanding_judgment ? "Yes" : "Off",
        borrower_b_no: declaration.bankrupt ? "Off" : "Yes",
        borrower_b_yes: declaration.bankrupt ? "Yes" : "Off",
        borrower_c_no: declaration.property_foreclosed ? "Off" : "Yes",
        borrower_c_yes: declaration.property_foreclosed ? "Yes" : "Off",
        borrower_d_no: declaration.party_to_lawsuit ? "Off" : "Yes",
        borrower_d_yes: declaration.party_to_lawsuit ? "Yes" : "Off",
        borrower_e_no: declaration.loan_foreclosure ? "Off" : "Yes",
        borrower_e_yes: declaration.loan_foreclosure ? "Yes" : "Off",
        borrower_f_no: declaration.present_delinquent_loan ? "Off" : "Yes",
        borrower_f_yes: declaration.present_delinquent_loan ? "Yes" : "Off",
        borrower_g_no: declaration.child_support ? "Off" : "Yes",
        borrower_g_yes: declaration.child_support ? "Yes" : "Off",
        borrower_h_no: declaration.down_payment_borrowed ? "Off" : "Yes",
        borrower_h_yes: declaration.down_payment_borrowed ? "Yes" : "Off",
        borrower_i_no: declaration.co_maker_or_endorser ? "Off" : "Yes",
        borrower_i_yes: declaration.co_maker_or_endorser ? "Yes" : "Off",
        borrower_j_no: declaration.us_citizen ? "Off" : "Yes",
        borrower_j_yes: declaration.us_citizen ? "Yes" : "Off",
        borrower_k_no: declaration.permanent_resident_alien ? "Off" : "Yes",
        borrower_k_yes: declaration.permanent_resident_alien ? "Yes" : "Off",
        borrower_m_no: declaration.ownership_interest ? "Off" : "Yes",
        borrower_m_yes: declaration.ownership_interest ? "Yes" : "Off",
        borrower_m1: declaration.type_of_property,
        borrower_m2: declaration.title_of_property
      })
    end
  end

  describe "#build_gross_monthly_income" do
    it "maps right values" do
      borrower = @service.borrower
      @service.build_gross_monthly_income("borrower", borrower)

      expect(@service.params).to include({
        borrower_base_income: "%.2f" % borrower.current_salary,
        borrower_overtime: "%.2f" % borrower.gross_overtime.to_f,
        borrower_bonuses: "%.2f" % borrower.gross_bonus.to_f,
        borrower_commissions: "%.2f" % borrower.gross_commission.to_f,
        borrower_total_monthly_income: "%.2f" % borrower.total_income.to_f
      })
    end
  end

  describe "#build_employment_info" do
    it "maps right values" do
      current_employment = @service.borrower.current_employment
      @service.build_employment_info("borrower", @service.borrower)

      expect(@service.params).to include({
        borrower_yrs_job_1: current_employment.duration,
        borrower_yrs_employed_1: current_employment.duration,
        borrower_self_employed_1: @service.borrower.self_employed ? "Yes" : "Off",
        borrower_employer_1: current_employment.employer_name,
        borrower_employer_street_1: current_employment.address.street_address,
        borrower_employer_city_state_1: "#{current_employment.address.city}, #{current_employment.address.state} #{current_employment.address.zip}",
        borrower_position_1: current_employment.job_title,
        borrower_business_phone_1: current_employment.employer_contact_number
      })
    end
  end

  describe "#build_borrower_info" do
    it "maps right values" do
      @service.borrower.marital_status = "married"
      @service.build_borrower_info("borrower", @service.borrower)

      expect(@service.params).to include({
        borrower_name: @service.borrower.full_name,
        borrower_ssn: @service.borrower.ssn,
        borrower_home_phone: @service.borrower.phone,
        borrower_dob: @service.borrower.dob.strftime("%m/%d/%Y"),
        borrower_yrs_school: @service.borrower.years_in_school,
        borrower_married: "Yes",
        borrower_dependents: @service.borrower.dependent_count,
        borrower_ages: @service.borrower.dependent_ages.join(", "),
        borrower_present_address: @service.borrower.display_current_address,
        borrower_no_yrs: @service.borrower.current_address.try(:years_at_address),
        borrower_former_address: @service.borrower.display_previous_address,
        borrower_former_no_yrs: @service.borrower.previous_address.try(:years_at_address)
      })
    end
  end

  describe "#build_loan_type" do
    it "marks 'x' to only one mortgage applied type" do
      @service.loan.loan_type = "Conventional"
      @service.build_section_1
      expect(@service.params[:fha]).not_to eq("Yes")
      expect(@service.params[:usda]).not_to eq("Yes")
      expect(@service.params[:va]).not_to eq("Yes")
      expect(@service.params[:loan_type_other]).not_to eq("Yes")
      expect(@service.params[:conventional]).to eq("Yes")
    end

    context "Conventional" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "Conventional"
        @service.build_section_1
        expect(@service.params[:conventional]).to eq("Yes")
      end
    end

    context "FHA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "FHA"
        @service.build_section_1
        expect(@service.params[:fha]).to eq("Yes")
      end
    end

    context "USDA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "USDA"
        @service.build_section_1
        expect(@service.params[:usda]).to eq("Yes")
      end
    end

    context "VA" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "VA"
        @service.build_section_1
        expect(@service.params[:va]).to eq("Yes")
      end
    end

    context "Other" do
      it "marks 'x' to param's mortgage applied" do
        @service.loan.loan_type = "LoremIpsum"
        @service.build_section_1
        expect(@service.params[:loan_type_other]).to eq("Yes")
      end
    end
  end

  describe "#build_refinance_loan" do
    it "maps right values relating to refinance" do
      property = @service.loan.subject_property
      @service.build_refinance_loan
      expect(@service.params).to include({
        purpose_refinance: "Yes",
        year_lot_acquired_2: property.original_purchase_year,
        original_cost_2: "%.2f" % property.original_purchase_price.to_f,
        amount_existing_liens_2: "%.2f" % property.refinance_amount,
        purpose_of_refinance: "Cash out",
        year_built: property.year_built
      })
    end
  end

  describe "#build_purchase_loan" do
    it "maps right values relating to refinance" do
      property = @service.loan.subject_property
      @service.build_purchase_loan
      expect(@service.params).to include({
        purpose_purchase: "Yes",
        source_down_payment: "Checking account"
      })
    end
  end
end
