require 'open-uri'

module Docusign
  module Templates
    class LoanEstimation
      def self.get_values_mapping_hash(user, loan)
        values = {
          "applicant_name" => "#{user.borrower.first_name} #{user.borrower.last_name} \n #{user.borrower.first_name} #{user.borrower.last_name}",
          "property" => loan.property.address.address,
          "sale_price" => loan.property.purchase_price,
          "purpose" => loan.purpose
        }

        case loan.amortization_type
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
            'loan_type_other_text' => loan.amortization_type,
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