# rubocop:disable ClassLength
include NumbersHelper

module Docusign
  module Templates
    class LoanEstimate
      attr_accessor :loan, :property, :borrower, :params

      def initialize(loan)
        @loan = loan
        @property = loan.property
        @borrower = loan.borrower
        @params = {}

        build_header
        build_loan_terms
        build_projected_payments
        build_cost_closing
        build_closing_cost_details
        build_additional_information
        remove_zero_value_from_params
      end

      def build_header
        @params['date_issued'] = Time.zone.today.in_time_zone.strftime("%D")
        @params['applicant_name'] = applicant_name
        @params['sale_price'] = Money.new(property.purchase_price).format
        @params['purpose'] = "#{loan.purpose}".titleize
        @params['product'] = "#{loan.amortization_type}".titleize
        @params['loan_term'] = loan.num_of_years.to_s + " years"
        @params['applicant_address'] = {
          width: 225,
          height: 30,
          value: borrower.current_address.try(:address).try(:address)
        }
        @params['property'] = {
          width: 225,
          height: 30,
          value: property.address.try(:address)
        }

        add_loan_type
        add_rate_lock
      end

      def build_loan_terms
        @params['loan_amount'] = Money.new(loan.amount).format
        @params['interest_rate'] = "#{(loan.interest_rate.to_f * 100).round(3)}%"
        @params['monthly_principal_interest'] = Money.new(loan.monthly_payment.round(2)).format
        @params['prepayment_penalty_amount'] = Money.new(loan.prepayment_penalty_amount.round(2)).format
        @params['prepayment_penalty_text'] = loan.prepayment_penalty_text
        @params['balloon_payment_text'] = loan.balloon_payment_text
        @params['prepayment_penalty_amount_tooltip'] = 'As high as'
        @params['loan_amount_increase'] = loan.loan_amount_increase ? 'YES' : 'NO'
        @params['interest_rate_increase'] = loan.interest_rate_increase ? 'YES' : 'NO'
        @params['monthly_principal_interest_increase'] = loan.monthly_principal_interest_increase ? 'YES' : 'NO'
        @params['prepayment_penalty'] = loan.prepayment_penalty ? 'YES' : 'NO'
        @params['balloon_payment'] = loan.balloon_payment ? 'YES' : 'NO'
      end

      def build_projected_payments
        @params['payment_calculation_text_1'] = 'Years 1-5'
        @params['projected_principal_interest_1'] = Money.new(loan.monthly_payment.round(2)).format
        @params['projected_mortgage_insurance_1'] = Money.new(loan.pmi.round(2)).format
        @params['estimated_escrow_1'] = Money.new(estimated_escrow).format
        @params['estimated_total_monthly_payment_1'] = Money.new(estimated_total_monthly_payment_1).format
        @params['estimated_taxes_insurance_assessments'] = Money.new(estimated_escrow).format
        @params['estimated_escrow_1_tooltip'] = '+'
        @params['estimated_taxes_insurance_assessments_text'] = 'a month'
        @params['projected_mortgage_insurance_1_tooltip'] = '+'
        @params['include_other_text'] = loan.include_other_text

        ['include_property_taxes', 'include_homeowners_insurance', 'include_other'].each do |key|
          @params[key] = 'x' if loan.method(key).call
        end

        ['in_escrow_property_taxes', 'in_escrow_homeowners_insurance', 'in_escrow_other'].each do |key|
          @params[key] = loan.method(key).call ? 'YES' : 'NO'
        end
      end

      def build_cost_closing
        map_number_to_params(
          [
            'estimated_closing_costs', 'loan_costs', 'other_costs', 'lender_credits', 'estimated_cash_to_close'
          ]
        )
      end

      def build_closing_cost_details
        origination_charges
        services_you_cannot_shop_for
        services_you_can_shop_for
        taxes_and_other_government_fees
        prepaids
        initial_escrow_payment_at_closing
        other_closing_cost
        sum_closing_costs
        calculating_cash_to_close

        @params['loan_costs_total'] = Money.new(loan_costs_total).format
        @params['total_other_costs'] = Money.new(total_other_costs).format
      end

      def build_additional_information
        lender_broker_info
        comparisons
        other_considerations
      end

      def remove_zero_value_from_params
        @params.reject! { |key| params[key] == "$0.00" }
      end

      private

      def origination_charges
        map_number_to_params(
          {
            'application_fee' => 'Application fee',
            'underwriting_fee' => 'Underwriting fee',
          }
        )

        @params['origination_charges_total'] = Money.new(origination_charges_total).format
        @params['points_text'] = "#{(loan.points.to_f * 100).round(3)}%"
        @params['points'] = Money.new((loan.points.to_f * loan.amount.to_f).round(3)).format
      end

      def services_you_cannot_shop_for
        map_number_to_params(
          {
            'appraisal_fee' => 'Appraisal fee',
            'credit_report_fee' => 'Credit Report Fee',
            'flood_determination_fee' => 'Flood Determination Fee',
            'flood_monitoring_fee' => 'Flood Monitoring Fee',
            'tax_monitoring_fee' => 'Tax Monitoring Fee',
            'tax_status_research_fee' => 'Tax Status Research Fee'
          }
        )

        @params['services_cannot_shop_total'] = Money.new(services_cannot_shop_total).format
      end

      def services_you_can_shop_for
        map_number_to_params(
          {
            'pest_inspection_fee' => 'Pest Inspection Fee',
            'survey_fee' => 'Survey Fee',
            'insurance_binder' => 'Title - Insurance Binder',
            'lenders_title_policy' => "Title - Lender's Title Policy",
            'settlement_agent_fee' => 'Title - Settlement Agent Fee',
            'title_search' => 'Title - Title Search'
          }
        )

        @params['services_can_shop_total'] = Money.new(services_can_shop_total).format
      end

      def taxes_and_other_government_fees
        map_number_to_params(
          ['recording_fees_and_other_taxes', 'transfer_taxes']
        )
        @params['taxes_and_other_government_fees_total'] = Money.new(taxes_and_other_government_fees_total).format
      end

      def prepaids
        map_number_to_params(
          [
            'homeowners_insurance_premium', 'mortgage_insurance_premium',
            'prepaid_interest_per_day', 'prepaid_property_taxes'
          ]
        )

        map_string_to_params(
          [
            'homeowners_insurance_premium_months', 'mortgage_insurance_premium_months',
            'prepaid_interest_days', 'prepaid_property_taxes_months'
          ]
        )

        @params['prepaid_interest'] = Money.new(prepaid_interest).format
        @params['prepaids_total'] = Money.new(prepaids_total).format
        @params['prepaid_interest_rate'] = "#{loan.prepaid_interest_rate.to_f * 100}%"
      end


      def initial_escrow_payment_at_closing
        map_number_to_params(
          [
            'initial_mortgage_insurance', 'initial_property_taxes_per_month', 'initial_property_taxes'
          ]
        )

        map_string_to_params(
          [
            'initial_homeowner_insurance_months', 'initial_mortgage_insurance_months', 'initial_property_taxes_months'
          ]
        )

        @params['initial_homeowner_insurance_per_month'] = property.estimated_hazard_insurance.round(2)
        @params['intial_mortgage_insurance_per_month'] = loan.pmi_monthly_premium_amount.round(2)
        @params['initial_homeowner_insurance'] = Money.new(initial_homeowner_insurance).format
        @params['intial_escrow_payment_total'] = Money.new(intial_escrow_payment_total).format
      end

      def add_loan_type
        case loan.loan_type
        when "Conventional"
          @params['loan_type_conventional'] = 'x'
        when "FHA"
          @params['loan_type_fha'] = 'x'
        when "VA"
          @params['loan_type_va'] = 'x'
        else
          @params['loan_type_other'] = 'x'
          @params['loan_type_other_text'] = loan.loan_type
        end
      end

      def add_rate_lock
        case loan.rate_lock
        when true
          @params['rate_lock_yes'] = 'x'
        when false
          @params['rate_lock_no'] = 'x'
        end
      end

      def applicant_name
        name = "#{borrower.first_name} #{borrower.last_name}".titleize
        if loan.secondary_borrower
          name += ' and ' "#{loan.secondary_borrower.first_name} #{loan.secondary_borrower.last_name}".titleize
        end
        name
      end

      def origination_charges_total
        @origination_charges_total ||= (loan.points.to_f * loan.amount.to_f + loan.application_fee.to_f + loan.underwriting_fee.to_f).round(2)
      end

      def estimated_total_monthly_payment_1
        @estimated_total_monthly_payment_1 ||= (loan.monthly_payment.to_f + loan.pmi.to_f + estimated_escrow).round(2)
      end

      def estimated_escrow
        @estimated_escrow ||= (property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f).round(2)
      end

      def services_cannot_shop_total
        @services_cannot_shop_total ||= (loan.appraisal_fee.to_f + loan.credit_report_fee.to_f +
                                        loan.flood_determination_fee.to_f + loan.flood_monitoring_fee.to_f +
                                        loan.tax_monitoring_fee.to_f + loan.tax_status_research_fee.to_f).round(2)
      end

      def services_can_shop_total
        @services_can_shop_total ||= (loan.pest_inspection_fee.to_f + loan.survey_fee.to_f + loan.insurance_binder.to_f +
                                     loan.lenders_title_policy.to_f + loan.settlement_agent_fee.to_f + loan.title_search.to_f).round(2)
      end

      def loan_costs_total
        @loan_costs_total ||= (origination_charges_total + services_cannot_shop_total + services_can_shop_total).round(2)
      end

      def taxes_and_other_government_fees_total
        @taxes_and_other_government_fees_total ||= (loan.recording_fees_and_other_taxes.to_f + loan.transfer_taxes.to_f).round(2)
      end

      def prepaid_interest
        @prepaid_interest ||= (loan.amount.to_f * loan.interest_rate.to_f * loan.prepaid_interest_days.to_i / 360).round(3)
      end

      def prepaids_total
        @prepaids_total ||= (loan.homeowners_insurance_premium.to_f + loan.mortgage_insurance_premium.to_f +
                            loan.prepaid_interest_per_day.to_f + prepaid_interest + loan.prepaid_property_taxes.to_f).round(2)
      end

      def intial_escrow_payment_total
        @intial_escrow_payment_total ||= (initial_homeowner_insurance.to_f + loan.initial_mortgage_insurance.to_f +
                                         loan.initial_property_taxes.to_f).round(2)
      end

      def initial_homeowner_insurance
        @pinitial_homeowner_insurance ||= (property.estimated_hazard_insurance.to_f * loan.initial_homeowner_insurance_months.to_f).round(2)
      end

      def total_other_costs
        @total_other_costs ||= (taxes_and_other_government_fees_total + prepaids_total + intial_escrow_payment_total + loan.owner_title_policy.to_f).round(2)
      end

      def other_closing_cost
        @params['owner_title_policy'] = @params['other_total'] = Money.new(loan.owner_title_policy.round(2)).format
        @params['owner_title_policy_text'] = 'Title - Owner Title Policy'
      end

      def sum_closing_costs
        @params['lender_credits'] = Money.new(loan.lender_credits.round(2)).format
        @params['total_loan_costs_and_other_costs'] = Money.new(total_loan_costs_and_other_costs).format
        @params['total_closing_costs'] = Money.new(total_closing_costs).format
      end

      def total_loan_costs_and_other_costs
        @total_loan_costs_and_other_costs ||= (loan_costs_total + total_other_costs).round(2)
      end

      def total_closing_costs
        @total_closing_costs ||= (loan.lender_credits.to_f + total_loan_costs_and_other_costs).round(2)
      end

      def calculating_cash_to_close
        map_number_to_params(
          [
            'closing_costs_financed', 'down_payment', 'deposit', 'funds_for_borrower', 'seller_credits', 'adjustments_and_other_credits'
          ]
        )
      end

      def lender_broker_info
        map_string_to_params(
          [
            'lender_name', 'lender_nmls_id', 'loan_officer_name_1', 'loan_officer_nmls_id_1',
            'loan_officer_email_1', 'loan_officer_phone_1', 'mortgage_broker_name',
            'mortgage_broker_nmls_id', 'loan_officer_name_2', 'loan_officer_nmls_id_2',
            'loan_officer_email_2', 'loan_officer_phone_2'
          ]
        )
      end

      def comparisons
        map_number_to_params(['in_5_years_total', 'in_5_years_principal'])
        @params['annual_percentage_rate'] = "#{(loan.annual_percentage_rate.to_f * 100).round(3)}%"
        @params['total_interest_percentage'] = "#{(loan.total_interest_percentage.to_f * 100).round(3)}%"
      end

      def other_considerations
        @params['assumption_will_allow'] = 'x' if loan.assumption_will_allow
        @params['assumption_will_not_allow'] = 'x' if loan.assumption_will_not_allow
        @params['servicing_service'] = 'x' if loan.servicing_service
        @params['servicing_transfer'] = 'x' if loan.servicing_transfer

        map_string_to_params(['late_days', 'late_fee_text'])
      end

      def map_string_to_params(list, object = loan)
        list.each do |key|
          @params[key] = object.method(key).call
        end
      end

      def map_number_to_params(list, object = loan)
        if list.class == Array
          list.each do |key|
            number = @loan.method(key).call
            @params[key] = Money.new(number.round(2)).format
          end
        else
          list.each do |key, value|
            number = @loan.method(key).call
            @params[key] = Money.new(number.round(2)).format
            @params["#{key}_text"] = value
          end
        end
      end
    end
  end
end

# default values for testing
# values.merge! ({
#   'date_issued' => Time.zone.today.in_time_zone.strftime("%D"),
#   'include_property_taxes_yes_no' => 'x',
#   'include_homeowners_insurance_yes_no' => 'x',
#   'include_other_yes_no' => 'x',
#   'include_other_text' => 'hardcode test'
# })