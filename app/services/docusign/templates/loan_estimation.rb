require 'open-uri'
include NumbersHelper

module Docusign
  module Templates
    class LoanEstimation
      def self.get_values_mapping_hash(user, loan)
        property = loan.property
        borrower = user.borrower

        estimated_escrow = number_with_precision(property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f)

        values = {
          "applicant_name" => "#{borrower.first_name} #{borrower.last_name}",
          "sale_price" => property.purchase_price,
          "purpose" => loan.purpose,
          "product" => loan.amortization_type,

          # Loan Terms
          "loan_amount" => loan.amount,
          "interest_rate" => loan.interest_rate,
          "monthly_principal_interest" => loan.monthly_payment,
          "prepayment_penalty" => loan.prepayment_penalty,
          "prepayment_penalty_amount" => loan.prepayment_penalty_amount,
          "balloon_payment" => loan.balloon_payment,

          # Projected Payments
          "projected_principal_interest_1" => loan.monthly_payment,
          "projected_mortgage_insurance_1" => loan.pmi,
          "estimated_total_monthly_payment_1" => number_with_precision(loan.pmi.to_f + property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f),
          "estimated_escrow_1" => estimated_escrow,
          "estimated_taxes_insurance_assessments" => estimated_escrow,

          # Costs at Closing
          "estimated_closing_costs" => loan.estimated_closing_costs
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

        values
      end
    end
  end
end