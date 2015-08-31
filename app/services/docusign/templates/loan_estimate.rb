require 'money'
include NumbersHelper

module Docusign
  module Templates
    class LoanEstimate
      attr_accessor :loan, :property, :borrower, :params

      def initialize(borrower, loan)
        @loan = loan
        @property = loan.property
        @borrower = borrower
        @params = {}

        build_header
        build_loan_terms
        build_projected_payments
        build_cost_closing
        build_closing_cost_details
      end

      private

      def build_header
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
        @params['loan_amount_increase'] = 'x' if loan.loan_amount_increase
        @params['interest_rate'] = "#{loan.interest_rate.to_f * 100}%"
        @params['interest_rate_increase'] = 'x' if loan.interest_rate_increase
        @params['monthly_principal_interest'] = Money.new(loan.monthly_payment).format
        @params['monthly_principal_interest_increase'] = 'x' if loan.monthly_principal_interest_increase
        @params['prepayment_penalty'] = Money.new(loan.prepayment_penalty).format
        @params['prepayment_penalty_amount'] = Money.new(loan.prepayment_penalty_amount).format
        @params['prepayment_penalty_amount_tooltip'] = 'As high as'
        @params['prepayment_penalty_text'] = loan.prepayment_penalty_text
        @params['balloon_payment'] = loan.balloon_payment
        @params['balloon_payment_text'] = loan.balloon_payment_text
      end

      def build_projected_payments
        @params['payment_calculation_text_1'] = Money.new(loan.payment_calculation).format
        @params['projected_principal_interest_1'] = Money.new(loan.monthly_payment).format
        @params['projected_mortgage_insurance_1'] = Money.new(loan.pmi).format
        @params['projected_mortgage_insurance_1_tooltip'] = '+'
        @params['estimated_escrow_1'] = Money.new(estimated_escrow).format
        @params['estimated_escrow_1_tooltip'] = '+'
        @params['estimated_total_monthly_payment_1'] = Money.new(estimated_total_monthly_payment_1).format
        @params['estimated_taxes_insurance_assessments'] = Money.new(estimated_escrow).format
        @params['estimated_taxes_insurance_assessments_text'] = 'a month'
        @params['include_property_taxes'] = 'x' if loan.include_property_taxes
        @params['include_homeowners_insurance'] = 'x' if loan.include_homeowners_insurance
        @params['include_other'] = 'x' if loan.include_other
        @params['include_other_text'] = 'x' if loan.include_other_text
        @params['in_escrow_property_taxes'] = 'x' if loan.in_escrow_property_taxes
        @params['in_escrow_homeowners_insurance'] = 'x' if loan.in_escrow_homeowners_insurance
        @params['in_escrow_other'] = 'x' if loan.in_escrow_other
      end

      def build_cost_closing
        @params['estimated_closing_costs'] = Money.new(loan.estimated_closing_costs).format
        @params['loan_costs'] = Money.new(loan.estimated_loan_costs).format
        @params['other_costs'] = Money.new(loan.estimated_other_costs).format
        @params['lender_credits'] = Money.new(loan.lender_credits).format
        @params['estimated_cash_to_close'] = Money.new(loan.estimated_cash_to_close).format
      end

      def build_closing_cost_details
        @params['origination_charges_total'] = Money.new(origination_charges_total).format
        @params['points_text'] = "#{loan.points.to_f * 100}%"
        @params['points'] = Money.new(loan.points * loan.amount).format if loan.points && loan.amount
        @params['application_fee'] = Money.new(loan.application_fee).format
        @params['underwriting_fee'] = Money.new(loan.underwriting_fee).format
        @params['services_cannot_shop_total'] = Money.new(loan.services_cannot_shop_total).format
        @params['appraisal_fee'] = Money.new(loan.appraisal_fee).format
        @params['credit_report_fee'] = Money.new(loan.credit_report_fee).format
        @params['flood_determination_fee'] = Money.new(loan.flood_determination_fee).format
        @params['flood_monitoring_fee'] = Money.new(loan.flood_monitoring_fee).format
        @params['tax_monitoring_fee'] = Money.new(loan.tax_monitoring_fee).format
        @params['tax_status_research_fee'] = Money.new(loan.tax_status_research_fee).format
        @params['services_can_shop_total'] = Money.new(loan.services_can_shop_total).format
        @params['pest_inspection_fee'] = Money.new(loan.pest_inspection_fee).format
        @params['survey_fee'] = Money.new(loan.survey_fee).format
        @params['insurance_binder'] = Money.new(loan.insurance_binder).format
        @params['lenders_title_policy'] = Money.new(loan.lenders_title_policy).format
        @params['settlement_agent_fee'] = Money.new(loan.settlement_agent_fee).format
        @params['title_search'] = Money.new(loan.title_search).format
        @params['loan_costs_total'] = Money.new(loan.loan_costs_total).format
        #@params['appraisal_fee_text'] = 'Appraisal fee'
        # @params['application_fee_text'] = 'Application fee'
        # @params['underwriting_fee_text'] = 'Underwriting fee'
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
        @origination_charges_total ||= loan.points * loan.amount.to_f + loan.application_fee + loan.underwriting_fee
      end

      def estimated_total_monthly_payment_1
        @estimated_total_monthly_payment_1 ||= loan.monthly_payment.to_f + loan.pmi.to_f + estimated_escrow
      end

      def estimated_escrow
        @estimated_escrow ||= property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f
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