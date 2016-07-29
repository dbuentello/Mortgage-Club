require "finance_formulas"

module Docusign
  module Templates
    #
    # Class UniformResidentialLoanApplication provides mapping values to Uniform Residential form.
    #
    class ExtraForm
      include FinanceFormulas
      include ActionView::Helpers::NumberHelper
      attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params, :field_names, :hash_data

      def initialize(loan, field_names)
        @loan = loan
        @subject_property = loan.subject_property
        @primary_property = get_primary_property
        @borrower = loan.borrower
        @credit_report = borrower.credit_report
        @field_names = field_names
        @hash_data = build_hash
        @params = {}
      end

      def build
        field_names.each do |f|
          arr_str = f.split(".")
          if arr_str[1].present?
            params[f] = hash_data[arr_str[0].to_sym]
          else
            params[f] = hash_data[f.to_sym]
          end
        end
        params
      end

      def build_hash
        # byebug
        {
          "borrower_full_name": borrower.full_name,
          "borrower_ssn": borrower.ssn,
          "borrower_email": borrower.user.email,
          "loan_property_address": subject_property.address.try(:address)
        }
      end

      def get_primary_property
        return unless loan.primary_property

        if subject_property_and_primary_property_have_same_address?(loan.primary_property)
          return loan.subject_property
        else
          return loan.primary_property
        end
      end
    end
  end
end
# rubocop:enable ClassLength
