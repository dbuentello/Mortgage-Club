module Docusign
  module Templates
    class UniformResidentialLoanApplication
      include ActionView::Helpers::NumberHelper
      attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params

      def initialize(loan)
        @loan = loan
        @subject_property = loan.subject_property
        @primary_property = loan.primary_property
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
        @params[:loan_amount] = number_with_delimiter(loan.amount.to_f)
        @params[:interest_rate] = "#{"%.3f" % (loan.interest_rate.to_f * 100)}"
        @params[:number_of_month] = loan.num_of_months
        @params[:arm_fixed_rate] = "Yes" if loan.fixed_rate_amortization?
        @params[:arm_type] = "Yes" if loan.arm_amortization?
      end

      def build_section_2
        @params[:subject_property_address] = subject_property.address.try(:address)
        @params[:no_units] = subject_property.no_of_unit
        @params[:subject_property_description] = "See preliminary title"
        @params[:purpose_purchase] = "Yes" if loan.purchase?
        @params[:primary_residence] = "Yes" if subject_property.primary_residence?
        @params[:secondary_residence] = "Yes" if subject_property.vacation_home?
        @params[:investment] = "Yes" if subject_property.rental_property?
        @params[:property_title] = "To Be Determined"
        @params[:property_manner] = "To Be Determined in escrow"
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

        @params[:borrower_rental_income] = number_with_delimiter(get_net_value)
        @params[:sum_total_income] = number_with_delimiter(@params[:total_base_income].to_f + @params[:total_overtime].to_f +
                                                       @params[:total_bonuses].to_f + @params[:total_commissions].to_f +
                                                       @params[:total_dividends].to_f)
        if @params[:sum_total_income]
          @params[:total_base_income] = number_with_delimiter(@params[:total_base_income].to_f)
          @params[:total_overtime] = number_with_delimiter(@params[:total_overtime].to_f)
          @params[:total_bonuses] = number_with_delimiter(@params[:total_bonuses].to_f)
          @params[:total_commissions] = number_with_delimiter(@params[:total_commissions].to_f)
          @params[:total_interest] = number_with_delimiter(@params[:total_dividends].to_f)
          @params[:total_rental_income] = number_with_delimiter(get_net_value)
        end
      end

      def build_section_6
        return unless credit_report

        credit_report.liabilities.includes(:address).each_with_index do |liability, index|
          nth = index.to_s
          @params[("liabilities_company_" + nth).to_sym] = liability.name
          if liability.address
            @params[("liabilities_street_" + nth).to_sym] = liability.address.street_address
            @params[("liabilities_city_state_" + nth).to_sym] = "#{liability.address.city}, #{liability.address.state} #{liability.address.zip}"
          end

          @params[("liabilities_payment_" + nth).to_sym] = number_with_delimiter(liability.payment.to_f / liability.months.to_f)
          @params[("liabilities_balance_" + nth).to_sym] = number_with_delimiter(liability.balance.to_f)
          @params[("liabilities_acc_" + nth).to_sym] = liability.account_number
        end
      end

      def build_section_7
        # leave blank now
        # subordinate_financing
        # closing_costs_paid_by_seller
        @params[:purchase_price] = "%.2f" % subject_property.purchase_price
        @params[:refinance] = "%.2f" % loan.amount if loan.refinance?
        @params[:prepaid_items] = "%.2f" % loan.estimated_prepaid_items.to_f
        @params[:closing_costs] = "%.2f" % loan.estimated_closing_costs.to_f
        @params[:pmi_mip] = "%.2f" % loan.pmi_mip_funding_fee.to_f
        @params[:other_credits] = "%.2f" % loan.other_credits.to_f
        @params[:loan_amount_exclude_pmi] = "%.2f" % (loan.amount - loan.pmi_mip_funding_fee.to_f)
        @params[:pmi_mip_financed] = "%.2f" % loan.pmi_mip_funding_fee_financed.to_f
        @params[:loan_amount_m_n] = "%.2f" % loan.amount
        @params[:borrower_cash] = "%.2f" % borrower_cash
        @params[:total_costs] = "%.2f" % total_cost_transactions
      end

      def build_section_8
        build_declaration("borrower", borrower)
        build_declaration("co_borrower", loan.secondary_borrower) if loan.secondary_borrower.present?
      end

      def build_section_10
        @params[:borrower_do_not_wish] = "Yes"
        @params[:co_borrower_do_not_wish] = "Yes" if loan.secondary_borrower
        @params[:applicant_submitted_internet] = "Yes"
      end

      def build_housing_expense(type, property)
        @params[(type + "_total").to_sym] = number_with_delimiter((property.mortgage_payment + property.other_financing +
                                            property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
                                            property.estimated_mortgage_insurance.to_f + property.hoa_due.to_f))

        @params[(type + "_rent").to_sym] = number_with_delimiter(borrower.current_address.monthly_rent) if primary_property && borrower.current_address.is_rental
        @params[(type + "_mortgage").to_sym] = number_with_delimiter(property.mortgage_payment)
        @params[(type + "_other_financing").to_sym] = number_with_delimiter(property.other_financing)
        @params[(type + "_hazard_insurance").to_sym] = number_with_delimiter(property.estimated_hazard_insurance)
        @params[(type + "_real_estate_taxes").to_sym] = number_with_delimiter(property.estimated_property_tax)
        @params[(type + "_mortgage_insurance").to_sym] = number_with_delimiter(property.estimated_mortgage_insurance)
        @params[(type + "_homeowner").to_sym] = number_with_delimiter(property.hoa_due)
      end

      def total_cost_transactions
        @total_cost_transactions ||=  (subject_property.purchase_price.to_f + loan.estimated_prepaid_items.to_f +
                                      loan.estimated_closing_costs.to_f + loan.pmi_mip_funding_fee.to_f).round(2)
      end

      def borrower_cash
        subordinate_financing = 0
        closing_costs_paid_by_seller = 0
        (total_cost_transactions - subordinate_financing - closing_costs_paid_by_seller -
          loan.other_credits.to_f - loan.amount.to_f).round(2)
      end

      def build_declaration(role, borrower)
        #declarations_borrower_l_yes
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
          "j" => "us_citizen",
          "k" => "permanent_resident_alien",
          "m" => "ownership_interest"
        }
        # Ex: @params["declarations_" + role + "_b_yes"] = "Yes" if declaration.bankrupt
        boolean_mapping.each do |key, field|
          @params[(prefix + key + yes_answer).to_sym] = @params[(prefix + key + no_answer).to_sym] = nil
          if declaration.send(field)
            @params[(prefix + key + yes_answer).to_sym] = "Yes"
          else
            @params[(prefix + key + no_answer).to_sym] = "Yes"
          end
        end
        @params[(prefix + "m1").to_sym] = declaration.type_of_property
        @params[(prefix + "m2").to_sym] = declaration.title_of_property
      end

      def build_gross_monthly_income(role, borrower)
        @params[(role + "_total_monthly_income").to_sym] = "%.2f" % borrower.total_income
        @params[(role + "_base_income").to_sym] = number_with_delimiter(borrower.current_salary)
        @params[(role + "_overtime").to_sym] = number_with_delimiter(borrower.gross_overtime)
        @params[(role + "_bonuses").to_sym] = number_with_delimiter(borrower.gross_bonus)
        @params[(role + "_commissions").to_sym] = number_with_delimiter(borrower.gross_commission)
        @params[(role + "_interest").to_sym] = number_with_delimiter(borrower.gross_interest)

        @params[:total_base_income] = @params[:total_base_income].to_f + borrower.current_salary
        @params[:total_overtime] = @params[:total_overtime].to_f + borrower.gross_overtime.to_f
        @params[:total_bonuses] = @params[:total_bonuses].to_f + borrower.gross_bonus.to_f
        @params[:total_commissions] = @params[:total_commissions].to_f + borrower.gross_commission.to_f
        @params[:total_dividends] = @params[:total_dividends].to_f + borrower.gross_interest.to_f
      end

      def build_employment_info(role, borrower)
        @params[(role + "_yrs_job_1").to_sym] = borrower.current_employment.duration
        @params[(role + "_yrs_employed_1").to_sym] = borrower.current_employment.duration

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
        @params[(role + "_dob").to_sym] = borrower.dob.strftime('%D') if borrower.dob
        @params[(role + "_yrs_school").to_sym] = borrower.years_in_school
        @params[(role + "_married").to_sym] = "Yes" if borrower.married?
        @params[(role + "_unmarried").to_sym] = "Yes" if borrower.unmarried?
        @params[(role + "_separated").to_sym] = "Yes" if borrower.separated?
        @params[(role + "_dependents").to_sym] = borrower.dependent_count
        @params[(role + "_ages").to_sym] = borrower.dependent_ages.join(", ")
        @params[(role + "_present_address").to_sym] = borrower.display_current_address
        @params[(role + "_own").to_sym] = "Yes" unless borrower.current_address.try(:is_rental)
        @params[(role + "_rent").to_sym] = "Yes" if borrower.current_address.try(:is_rental)
        @params[(role + "_no_yrs").to_sym] = borrower.current_address.try(:years_at_address)
        @params[(role + "_former_address").to_sym] = borrower.display_previous_address
        @params[(role + "_former_own").to_sym] = "Yes" unless borrower.previous_address.try(:is_rental)
        @params[(role + "_former_rent").to_sym] = "Yes" if borrower.previous_address.try(:is_rental)
        @params[(role + "_former_no_yrs").to_sym] = borrower.previous_address.try(:years_at_address)
      end

      def build_refinance_loan
        @params[:purpose_refinance] = "Yes"
        @params[:year_lot_acquired_2] = subject_property.original_purchase_year
        @params[:original_cost_2] = number_with_delimiter(subject_property.original_purchase_price)
        @params[:amount_existing_liens_2] = number_with_delimiter(subject_property.refinance_amount)

        if loan.amount > subject_property.total_liability_balance
          @params[:purpose_of_refinance] = "Cash out"
        else
          @params[:purpose_of_refinance] = "Rate and term"
        end
        @params[:year_built] = subject_property.year_built
        @params[:source_down_payment] = "Checking account"
      end

      def build_purchase_loan
        @params[:purpose_purchase] = "Yes"
        @params[:original_cost_1] = number_with_delimiter(subject_property.purchase_price)
        @params[:source_down_payment] = "Checking account"
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
    end
  end
end
