# rubocop:disable ClassLength
require "finance_formulas"

module Docusign
  module Templates
    #
    # Class UniformResidentialLoanApplication provides mapping values to Uniform Residential form.
    #
    #
    #
    class UniformResidentialLoanApplication
      include FinanceFormulas
      include ActionView::Helpers::NumberHelper
      attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params

      def initialize(loan)
        @loan = loan
        @subject_property = loan.subject_property
        @primary_property = get_primary_property
        @borrower = loan.borrower
        @credit_report = borrower.credit_report
        @params = {}
      end

      def build
        build_section_1
        build_section_2
        build_section_3
        build_section_4
        build_section_5
        build_section_6
        build_section_7
        build_section_8
        build_section_10
        params
      end

      def build_section_1
        build_loan_type
        @params[:has_co_borrower] = "Yes" if loan.secondary_borrower.present?
        @params[:loan_amount] = number_with_delimiter(loan.amount.to_f.round)
        @params[:interest_rate] = format("%0.03f", loan.interest_rate.to_f * 100)
        @params[:number_of_months] = loan.num_of_months
        @params[:arm_fixed_rate] = "Yes" if loan.fixed_rate_amortization?
        if loan.arm_amortization?
          @params[:arm_type] = "Yes"
          @params[:arm_type_explain] = loan.amortization_type
        end
      end

      def build_section_2
        @params[:subject_property_address] = subject_property.address.try(:address)
        @params[:no_units] = subject_property.no_of_unit
        @params[:subject_property_description] = "See preliminary title"
        @params[:purpose_purchase] = "Yes" if loan.purchase?
        @params[:primary_residence] = "Yes" if subject_property.primary_residence?
        @params[:secondary_residence] = "Yes" if subject_property.vacation_home?
        @params[:investment] = "Yes" if subject_property.rental_property?
        @params[:property_title] = "To be determined"
        @params[:property_manner] = "To be determined in escrow"
        @params[:fee_simple] = "Yes"

        if loan.purchase?
          build_purchase_loan
        else
          build_refinance_loan
        end
      end

      def build_section_3
        build_borrower_info("borrower", borrower)
        build_borrower_info("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_section_4
        build_employment_info("borrower", borrower)
        build_employment_info("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
        # TODO: add previous employment when duration < 2
      end

      def build_section_5
        build_gross_monthly_income("borrower", borrower)
        build_gross_monthly_income("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
        build_housing_expense("proposed", subject_property)
        build_housing_expense("present", primary_property) if primary_property

        @params[:borrower_rental_income] = number_to_currency(get_net_value, unit: "")
        @params[:borrower_total_monthly_income] = number_to_currency(@params[:borrower_total_monthly_income] + get_net_value, unit: "")
        @params[:sum_total_income] = number_to_currency((@params[:total_base_income].to_f + @params[:total_overtime].to_f +
                                                       @params[:total_bonuses].to_f + @params[:total_commissions].to_f +
                                                       @params[:total_dividends].to_f + get_net_value), unit: "")
        if @params[:sum_total_income]
          @params[:total_base_income] = number_to_currency(@params[:total_base_income].to_f, unit: "")
          @params[:total_overtime] = number_to_currency(@params[:total_overtime].to_f, unit: "")
          @params[:total_bonuses] = number_to_currency(@params[:total_bonuses].to_f, unit: "")
          @params[:total_commissions] = number_to_currency(@params[:total_commissions].to_f, unit: "")
          @params[:total_interest] = number_to_currency(@params[:total_dividends].to_f, unit: "")
          @params[:total_rental_income] = number_to_currency(get_net_value, unit: "")
        end
      end

      def build_section_6
        build_liabilities
        build_assets
        build_property_address
      end

      def build_section_7
        # leave blank now
        # subordinate_financing
        # closing_costs_paid_by_seller
        @params[:purchase_price] = number_to_currency(subject_property.purchase_price.to_f, unit: "")
        @params[:refinance] = number_to_currency(loan.amount, unit: "") if loan.refinance?
        @params[:prepaid_items] = number_to_currency(loan.estimated_prepaid_items.to_f, unit: "")
        @params[:closing_costs] = number_to_currency(loan.estimated_closing_costs.to_f, unit: "")
        @params[:pmi_mip] = number_to_currency(loan.pmi_mip_funding_fee.to_f, unit: "")
        @params[:other_credits] = number_to_currency(loan.other_credits.to_f, unit: "")
        @params[:loan_amount_exclude_pmi] = number_to_currency((loan.amount - loan.pmi_mip_funding_fee.to_f), unit: "")
        @params[:pmi_mip_financed] = number_to_currency(loan.pmi_mip_funding_fee_financed.to_f, unit: "")
        @params[:loan_amount_m_n] = number_to_currency(loan.amount, unit: "")
        @params[:borrower_cash] = number_to_currency((borrower_cash), unit: "")
        @params[:total_costs] = number_to_currency((total_cost_transactions), unit: "")
      end

      def build_section_8
        build_declaration("borrower", borrower)
        @params[:borrower_l_yes] = @params[:borrower_l_no] = "Off"
        if loan.subject_property.usage == "primary_residence"
          @params[:borrower_l_yes] = "Yes"
        else
          @params[:borrower_l_no] = "Yes"
        end
        build_declaration("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_section_10
        @params[:borrower_do_not_wish] = "Yes"
        @params[:co_borrower_do_not_wish] = "Yes" if loan.secondary_borrower
        @params[:applicant_submitted_internet] = "Yes"
        @params[:loan_originator_name] = loan.relationship_manager.user.first_name + " " + loan.relationship_manager.user.last_name if loan.relationship_manager
        @params[:individual_nmls] = loan.relationship_manager.nmls_id if loan.relationship_manager
        @params[:individual_phone_number] = loan.relationship_manager.phone_number if loan.relationship_manager
        @params[:company_name] = loan.relationship_manager.company_name if loan.relationship_manager
        @params[:company_nmls] = loan.relationship_manager.company_nmls if loan.relationship_manager
        @params[:company_address] = loan.relationship_manager.company_address if loan.relationship_manager
      end

      def build_assets
        count = 0
        borrower.assets.each do |asset|
          count += 1
          nth = count.to_s
          @params[("asset_" + nth).to_sym] = asset.institution_name
          @params[("asset_balance_" + nth).to_sym] = number_to_currency(asset.current_balance.to_f, unit: "")
        end
      end

      def build_property_address
        count = 0
        total_market_price = 0
        total_liens = 0
        total_rental_property_income = 0
        loan.properties.each do | p |
          if !p.is_primary && !p.is_subject
            count += 1
            nth = count.to_s
            @params["rental_property_address_" + nth] = p.address.full_text
            @params["rental_property_status_" + nth] = "R"
            @params["rental_property_type_" + nth] = get_property_type(p.property_type)
            @params["rental_property_market_price_" + nth] = p.market_price
            @params["rental_property_income_" + nth] = p.gross_rental_income
            @params["rental_property_liens_" + nth] = p.total_liability_balance
            total_market_price += p.market_price
            total_liens += p.total_liability_balance
            total_rental_property_income += p.gross_rental_income
          end
        end
        @params["total_market_price"] = total_market_price
        @params["total_liens"] = total_liens
        @params["total_rental_property_income"] = total_rental_property_income
      end

      def get_property_type(property_type)
        case property_type
        when "sfh"
          "SFR"
        when "duplex"
          "2-4"
        when "triplex"
          "2-4"
        when "fourplex"
          "2-4"
        else
          "SFR"
        end
      end


      def build_liabilities
        return unless credit_report
        count = 0

        credit_report.liabilities.includes(:address).each do |liability|
          count += 1
          nth = count.to_s
          @params[("liabilities_company_" + nth).to_sym] = liability.name
          if liability.address
            @params[("liabilities_street_" + nth).to_sym] = liability.address.street_address
            @params[("liabilities_city_state_" + nth).to_sym] = "#{liability.address.city}, #{liability.address.state} #{liability.address.zip}"
          end

          @params[("liabilities_payment_" + nth).to_sym] = "#{number_to_currency(liability.payment.to_f, unit: '')} / #{liability.months.to_i}"
          @params[("liabilities_balance_" + nth).to_sym] = number_to_currency(liability.balance.to_f, unit: "")
          @params[("liabilities_acc_" + nth).to_sym] = liability.account_number
        end
      end

      def build_housing_expense(type, property)
        @params[(type + "_total").to_sym] = number_to_currency(property.mortgage_payment.to_f + property.other_financing.to_f +
                                            get_monthly_value(property.estimated_hazard_insurance) + get_monthly_value(property.estimated_property_tax) +
                                            property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f, unit: "")

        @params[(type + "_rent").to_sym] = number_to_currency(borrower.current_address.monthly_rent, unit: "") if primary_property && borrower.current_address.is_rental
        @params[(type + "_mortgage").to_sym] = number_to_currency(property.mortgage_payment.to_f, unit: "")
        @params[(type + "_other_financing").to_sym] = number_to_currency(property.other_financing.to_f, unit: "")
        @params[(type + "_hazard_insurance").to_sym] = number_to_currency(get_monthly_value(property.estimated_hazard_insurance), unit: "")
        @params[(type + "_real_estate_taxes").to_sym] = number_to_currency(get_monthly_value(property.estimated_property_tax), unit: "")
        @params[(type + "_mortgage_insurance").to_sym] = number_to_currency(property.estimated_mortgage_insurance.to_f, unit: "")
        @params[(type + "_homeowner").to_sym] = number_to_currency(property.hoa_due.to_f, unit: "")
      end

      def total_cost_transactions
        @total_cost_transactions ||= (subject_property.purchase_price.to_f + loan.estimated_prepaid_items.to_f +
                                      loan.estimated_closing_costs.to_f + loan.pmi_mip_funding_fee.to_f).round(2)
      end

      def borrower_cash
        subordinate_financing = 0
        closing_costs_paid_by_seller = 0
        (total_cost_transactions - subordinate_financing - closing_costs_paid_by_seller -
          loan.other_credits.to_f - loan.amount.to_f).round(2)
      end

      def build_declaration(role, borrower)
        # declarations_borrower_l_yes
        return unless declaration = borrower.declaration
        prefix = (role + "_").freeze
        yes_answer = "_yes".freeze
        no_answer = "_no".freeze
        boolean_mapping = {
          "a" => "outstanding_judgment",
          "b" => "bankrupt",
          "c" => "property_foreclosed",
          "d" => "party_to_lawsuit",
          "e" => "loan_foreclosure",
          "f" => "present_delinquent_loan",
          "g" => "child_support",
          "h" => "down_payment_borrowed",
          "i" => "co_maker_or_endorser",
          "m" => "ownership_interest"
        }
        # Ex: @params["declarations_" + role + "_b_yes"] = "Yes" if declaration.bankrupt
        boolean_mapping.each do |key, field|
          @params[(prefix + key + yes_answer).to_sym] = @params[(prefix + key + no_answer).to_sym] = "Off"
          if declaration.send(field)
            @params[(prefix + key + yes_answer).to_sym] = "Yes"
          else
            @params[(prefix + key + no_answer).to_sym] = "Yes"
          end
        end

        if declaration.citizen_status == "C"
          @params[(prefix + "j" + yes_answer).to_sym] = "Yes"
          @params[(prefix + "j" + no_answer).to_sym] = "Off"
        else
          @params[(prefix + "j" + no_answer).to_sym] = "Yes"
          @params[(prefix + "j" + yes_answer).to_sym] = "Off"
        end

        if declaration.citizen_status == "PR"
          @params[(prefix + "k" + yes_answer).to_sym] = "Yes"
          @params[(prefix + "k" + no_answer).to_sym] = "Off"
        else
          @params[(prefix + "k" + no_answer).to_sym] = "Yes"
          @params[(prefix + "k" + yes_answer).to_sym] = "Off"
        end

        @params[(prefix + "m1").to_sym] = declaration.type_of_property
        @params[(prefix + "m2").to_sym] = declaration.title_of_property
      end

      def build_gross_monthly_income(role, borrower)
        @params[(role + "_total_monthly_income").to_sym] = build_total_monthly_income(borrower)
        @params[(role + "_base_income").to_sym] = number_to_currency(build_monthly_income(borrower.current_salary.to_f, borrower.pay_frequency), unit: "")
        @params[(role + "_overtime").to_sym] = number_to_currency(borrower.gross_overtime.to_f, unit: "")
        @params[(role + "_bonuses").to_sym] = number_to_currency(borrower.gross_bonus.to_f, unit: "")
        @params[(role + "_commissions").to_sym] = number_to_currency(borrower.gross_commission.to_f, unit: "")
        @params[(role + "_interest").to_sym] = number_to_currency(borrower.gross_interest.to_f, unit: "")

        @params[:total_base_income] = @params[:total_base_income].to_f + build_monthly_income(borrower.current_salary.to_f, borrower.pay_frequency)
        @params[:total_overtime] = @params[:total_overtime].to_f + borrower.gross_overtime.to_f
        @params[:total_bonuses] = @params[:total_bonuses].to_f + borrower.gross_bonus.to_f
        @params[:total_commissions] = @params[:total_commissions].to_f + borrower.gross_commission.to_f
        @params[:total_dividends] = @params[:total_dividends].to_f + borrower.gross_interest.to_f
      end

      def build_total_monthly_income(borrower)
        borrower.gross_overtime.to_f + borrower.gross_bonus.to_f + borrower.gross_bonus.to_f + borrower.gross_commission.to_f + borrower.gross_interest.to_f + build_monthly_income(borrower.current_salary.to_f, borrower.pay_frequency)
      end

      def build_monthly_income(current_salary, pay_frequency)
        case pay_frequency # a_variable is the variable we want to compare
        when "monthly"
          current_salary
        when "biweekly"
          current_salary = (current_salary * 26) / 12
        when "weekly"
          current_salary = (current_salary * 52) / 12
        else
          current_salary *= 2
        end
        current_salary.to_f
      end

      def build_employment_info(role, borrower)
        @params[(role + "_yrs_job_1").to_sym] = borrower.current_employment.duration
        @params[(role + "_yrs_employed_1").to_sym] = borrower.current_employment.duration
        @params[(role + "_self_employed_1").to_sym] = borrower.self_employed ? "Yes" : "Off"
        if borrower.previous_employment.present?
          @params[(role + "_monthly_income_2").to_sym] = borrower.previous_employment.monthly_income
        end
        [borrower.current_employment, borrower.previous_employment].each_with_index do |employment, index|
          next if employment.nil?

          @params[(role + "_employer_#{index + 1}").to_sym] = employment.employer_name
          if employment.address
            @params[(role + "_employer_street_#{index + 1}").to_sym] = employment.address.street_address
            @params[(role + "_employer_city_state_#{index + 1}").to_sym] = "#{employment.address.city}, #{employment.address.state} #{employment.address.zip}"
          end
          @params[(role + "_position_#{index + 1}").to_sym] = employment.job_title
          @params[(role + "_business_phone_#{index + 1}").to_sym] = employment.employer_contact_number
        end
      end

      def build_borrower_info(role, borrower)
        @params[(role + "_name").to_sym] = borrower.full_name
        @params[(role + "_ssn").to_sym] = borrower.ssn
        @params[(role + "_home_phone").to_sym] = borrower.phone
        @params[(role + "_dob").to_sym] = borrower.dob.strftime("%m/%d/%Y") if borrower.dob
        @params[(role + "_yrs_school").to_sym] = borrower.years_in_school
        @params[(role + "_married").to_sym] = "Yes" if borrower.married?
        @params[(role + "_unmarried").to_sym] = "Yes" if borrower.unmarried?
        @params[(role + "_separated").to_sym] = "Yes" if borrower.separated?
        @params[(role + "_dependents").to_sym] = borrower.dependent_count
        @params[(role + "_ages").to_sym] = borrower.dependent_ages.join(", ")
        build_address(role, borrower)
      end

      def build_address(role, borrower)
        @params[(role + "_present_address").to_sym] = borrower.display_current_address
        if borrower.display_current_address
          @params[(role + "_own").to_sym] = "Yes" unless borrower.current_address.try(:is_rental)
          @params[(role + "_rent").to_sym] = "Yes" if borrower.current_address.try(:is_rental)
          @params[(role + "_no_yrs").to_sym] = borrower.current_address.try(:years_at_address)
        end

        @params[(role + "_former_address").to_sym] = borrower.display_previous_address
        if borrower.display_previous_address
          @params[(role + "_former_own").to_sym] = "Yes" unless borrower.previous_address.try(:is_rental)
          @params[(role + "_former_rent").to_sym] = "Yes" if borrower.previous_address.try(:is_rental)
          @params[(role + "_former_no_yrs").to_sym] = borrower.previous_address.try(:years_at_address)
        end
      end

      def build_refinance_loan
        @params[:purpose_refinance] = "Yes"
        @params[:year_lot_acquired_2] = subject_property.original_purchase_year
        @params[:original_cost_2] = number_to_currency(subject_property.original_purchase_price, unit: "")
        @params[:amount_existing_liens_2] = number_to_currency(subject_property.refinance_amount, unit: "")

        if loan.amount > subject_property.total_liability_balance
          @params[:purpose_of_refinance] = "Cash out"
        else
          @params[:purpose_of_refinance] = "Rate and term"
        end
        @params[:year_built] = subject_property.year_built
        @params[:source_down_payment] = "Checking/Savings"
      end

      def build_purchase_loan
        @params[:purpose_purchase] = "Yes"
        @params[:source_down_payment] = "Checking/Savings"
      end

      def build_loan_type
        case loan.loan_type
        when "Conventional"
          @params[:conventional] = "Yes"
        when "FHA"
          @params[:fha] = "Yes"
        when "USDA"
          @params[:usda] = "Yes"
        when "VA"
          @params[:va] = "Yes"
        else
          @params[:loan_type_other] = "Yes"
          @params[:loan_type_other_explain] = loan.loan_type
        end
      end

      def get_net_value
        @net_value ||= UnderwritingLoanServices::CalculateRentalIncome.call(loan)
      end

      def get_primary_property
        return unless loan.primary_property

        if subject_property_and_primary_property_have_same_address?(loan.primary_property)
          return loan.subject_property
        else
          return loan.primary_property
        end
      end

      def subject_property_and_primary_property_have_same_address?(primary_property)
        return false unless subject_address = subject_property.address
        return false unless primary_address = primary_property.address

        subject_address.city == primary_address.city &&
          subject_address.state == primary_address.state &&
          subject_address.street_address == primary_address.street_address &&
          subject_address.zip == primary_address.zip
      end
    end
  end
end
# rubocop:enable ClassLength
