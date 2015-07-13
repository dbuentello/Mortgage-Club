require 'open-uri'

module Docusign
  module Templates
    class LoanEstimation
      def self.get_values_mapping_hash(user, loan)
        property = loan.property

        estimated_escrow = (property.estimated_hazard_insurance + property.estimated_property_tax)

        values = {
          "applicant_name" => "#{user.borrower.first_name} #{user.borrower.last_name}",
          "property" => property.address.address,
          "applicant_address" => user.borrower.borrower_addresses.first.address.address,
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
          "estimated_escrow_1" => estimated_escrow,
          "estimated_total_monthly_payment_1" => (loan.pmi + property.estimated_hazard_insurance + property.estimated_property_tax),
          "estimated_taxes_insurance_assessments" => estimated_escrow,

          # Costs at Closing
          "estimated_closing_costs" => loan.estimated_closing_costs
        }

        case loan.loan_type
        when "Conventional"
          values.merge! ({
            'loan_type_conventional' => 'x',
            'loan_type_fha' => '',
            'loan_type_va' => ''
          })
        when "FHA"
          values.merge! ({
            'loan_type_conventional' => '',
            'loan_type_fha' => 'x',
            'loan_type_va' => ''
          })
        when "VA"
          values.merge! ({
            'loan_type_conventional' => '',
            'loan_type_fha' => '',
            'loan_type_va' => 'x'
          })
        else
          values.merge! ({
            'loan_type_other' => 'x',
            'loan_type_other_text' => loan.loan_type,
            'loan_type_conventional' => '',
            'loan_type_fha' => '',
            'loan_type_va' => ''
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