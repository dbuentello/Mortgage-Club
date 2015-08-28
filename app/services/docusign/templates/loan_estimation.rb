require 'open-uri'
require 'money'

include NumbersHelper

module Docusign
  module Templates
    class LoanEstimation
      def self.get_values_mapping_hash(user, loan)
        property = loan.property
        borrower = user.borrower

        estimated_escrow = property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f
        estimated_total_monthly_payment_1 = loan.monthly_payment.to_f + loan.pmi.to_f + estimated_escrow

        # the name is from 'tooltip' of field in the template
        values = {
          "applicant_name" => "#{borrower.first_name} #{borrower.last_name}".titleize,
          "sale_price" => Money.new(property.purchase_price).format,
          "purpose" => "#{loan.purpose}".titleize,
          "product" => "#{loan.amortization_type}".titleize,

          # Loan Terms
          "loan_amount" => Money.new(loan.amount).format,
          "interest_rate" => "#{loan.interest_rate}%",
          "monthly_principal_interest" => Money.new(loan.monthly_payment).format,
          "prepayment_penalty" => Money.new(loan.prepayment_penalty).format,
          "prepayment_penalty_amount" => Money.new(loan.prepayment_penalty_amount).format,
          "prepayment_penalty_amount_tooltip" => 'As high',
          "balloon_payment" => loan.balloon_payment,

          # Projected Payments
          "projected_principal_interest_1" => Money.new(loan.monthly_payment).format,
          "projected_mortgage_insurance_1" => Money.new(loan.pmi).format,
          "projected_mortgage_insurance_1_tooltip" => '+',
          "estimated_escrow_1" => Money.new(estimated_escrow).format,
          "estimated_escrow_1_tooltip" => '+',
          "estimated_total_monthly_payment_1" => Money.new(estimated_total_monthly_payment_1).format,

          "estimated_taxes_insurance_assessments" => Money.new(estimated_escrow).format,
          "estimated_taxes_insurance_assessments_tooltip" => 'a month',

          # Costs at Closing
          "estimated_closing_costs" => Money.new(loan.estimated_closing_costs).format
        }

        if borrower.borrower_addresses.first.present? && borrower.borrower_addresses.first.address.present?
          values.merge! ({
            "applicant_address" => {
              width: 225,
              height: 30,
              value: borrower.borrower_addresses.first.address.address
            }
          })
        end

        if property.address.present?
          values.merge! ({
            "property" => {
              width: 225,
              height: 30,
              value: property.address.address
            },
          })
        end

        case loan.loan_type
        when "Conventional"
          values.merge! ({
            'loan_type_conventional' => 'x'
          })
        when "FHA"
          values.merge! ({
            'loan_type_fha' => 'x'
          })
        when "VA"
          values.merge! ({
            'loan_type_va' => 'x'
          })
        else
          values.merge! ({
            'loan_type_other' => 'x',
            'loan_type_other_text' => loan.loan_type
          })
        end

        case loan.rate_lock
        when false
          values.merge! ({
            'rate_lock_no' => 'x'
          })
        when true
          values.merge! ({
            'rate_lock_yes' => 'x'
          })
        end

        # default values for testing
        values.merge! ({
          'date_issued' => Time.zone.today.to_time.strftime("%D"),
          'include_property_taxes_yes_no' => 'x',
          'include_homeowners_insurance_yes_no' => 'x',
          'include_other_yes_no' => 'x',
          'include_other_text' => 'hardcode test'
        })

        values
      end
    end
  end
end