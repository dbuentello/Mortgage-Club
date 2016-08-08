require "finance_formulas"

module Docusign
  module Templates
    #
    # Class UniformResidentialLoanApplication provides mapping values to Uniform Residential form.
    #
    class ExtraForm
      include FinanceFormulas
      include ActionView::Helpers::NumberHelper
      attr_accessor :loan, :borrower, :co_borrower, :subject_property, :primary_property, :credit_report, :params, :field_names, :hash_data

      def initialize(loan, field_names)
        @loan = loan
        @subject_property = loan.subject_property
        @primary_property = get_primary_property
        @borrower = loan.borrower
        @credit_report = borrower.credit_report
        @field_names = field_names
        @hash_data = build_hash
        @params = {}
        loan.secondary_borrower.present? ? @co_borrower = loan.secondary_borrower : @co_borrower = nil
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
        hash = {
          "borrower_full_name": borrower.full_name,
          "borrower_ssn": borrower.ssn,
          "borrower_phone": borrower.phone,
          "borrower_email": borrower.user.email,
          "loan_property_address": subject_property.address.try(:address),
          "borrower_current_address": borrower.display_current_address,
          "borrower_current_address_city": borrower.current_address.try(:address).city,
          "borrower_current_address_state": borrower.current_address.try(:address).state,
          "borrower_current_address_zip": borrower.current_address.try(:address).zip,
          "borrower_dob": borrower.dob.to_date,
          "date_signed": Time.zone.now.to_date,
          "borrower_previous_address": borrower.display_previous_address
        }
        hash << build_hash_co_borrower if @co_borrower.present?
        hash
      end

      def build_hash_co_borrower
        {
          "co_borrower_full_name": co_borrower.full_name,
          "co_borrower_ssn": co_borrower.ssn,
          "co_borrower_phone": co_borrower.phone,
          "co_borrower_email": co_borrower.user.email,
          "co_borrower_current_address": co_borrower.display_current_address,
          "co_borrower_current_address_city": co_borrower.current_address.try(:address).city,
          "co_borrower_current_address_state": co_borrower.current_address.try(:address).state,
          "co_borrower_current_address_zip": co_borrower.current_address.try(:address).zip,
          "co_borrower_dob": co_borrower.dob.to_date,
          "co_borrower_previous_address": co_borrower.display_previous_address
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
