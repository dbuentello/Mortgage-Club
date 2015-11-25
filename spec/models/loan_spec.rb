# == Schema Information
#
# Table name: loans
#
#  id                                  :uuid             not null, primary key
#  purpose                             :integer
#  user_id                             :uuid
#  agency_case_number                  :string
#  lender_case_number                  :string
#  amount                              :decimal(11, 2)
#  interest_rate                       :decimal(9, 3)
#  num_of_months                       :integer
#  amortization_type                   :string
#  rate_lock                           :boolean
#  refinance                           :decimal(11, 2)
#  estimated_prepaid_items             :decimal(11, 2)
#  estimated_closing_costs             :decimal(11, 2)
#  pmi_mip_funding_fee                 :decimal(11, 2)
#  borrower_closing_costs              :decimal(11, 2)
#  other_credits                       :decimal(11, 2)
#  other_credits_explain               :string
#  pmi_mip_funding_fee_financed        :decimal(11, 2)
#  loan_type                           :string
#  prepayment_penalty                  :boolean
#  balloon_payment                     :boolean
#  monthly_payment                     :decimal(11, 2)
#  prepayment_penalty_amount           :decimal(11, 2)
#  pmi                                 :decimal(11, 2)
#  loan_amount_increase                :boolean
#  interest_rate_increase              :boolean
#  included_property_taxes             :boolean
#  included_homeowners_insurance       :boolean
#  included_other                      :boolean
#  included_other_text                 :boolean
#  in_escrow_property_taxes            :boolean
#  in_escrow_homeowners_insurance      :boolean
#  in_escrow_other                     :boolean
#  loan_costs                          :decimal(11, 2)
#  other_costs                         :decimal(11, 2)
#  lender_credits                      :decimal(11, 2)
#  estimated_cash_to_close             :decimal(11, 2)
#  lender_name                         :string
#  fha_upfront_premium_amount          :decimal(11, 2)
#  term_months                         :integer
#  lock_period                         :integer
#  margin                              :decimal(11, 2)
#  pmi_annual_premium_mount            :decimal(11, 2)
#  pmi_monthly_premium_amount          :decimal(11, 2)
#  pmi_monthly_premium_percent         :decimal(11, 4)
#  pmi_required                        :boolean
#  apr                                 :decimal(11, 3)
#  price                               :decimal(11, 3)
#  product_code                        :string
#  product_index                       :integer
#  total_margin_adjustment             :decimal(11, 2)
#  total_price_adjustment              :decimal(11, 2)
#  total_rate_adjustment               :decimal(11, 2)
#  srp_adjustment                      :decimal(11, 2)
#  appraisal_fee                       :decimal(11, 2)
#  city_county_deed_stamp_fee          :decimal(11, 2)
#  credit_report_fee                   :decimal(11, 2)
#  document_preparation_fee            :decimal(11, 2)
#  flood_certification                 :decimal(11, 2)
#  origination_fee                     :decimal(11, 2)
#  settlement_fee                      :decimal(11, 2)
#  state_deed_tax_stamp_fee            :decimal(11, 2)
#  tax_related_service_fee             :decimal(11, 2)
#  title_insurance_fee                 :decimal(11, 2)
#  monthly_principal_interest_increase :boolean
#

require 'rails_helper'

describe Loan do
  let(:loan) { FactoryGirl.create(:loan) }

  it 'has a valid factory' do
    expect(loan).to be_valid
  end

  it 'has a valid with_loan_activites factory' do
    loan = FactoryGirl.build(:loan_with_activites)
    expect(loan).to be_valid
    expect(loan.loan_activities.size).to be >= 1
  end

  describe '.primary_property' do
    context 'primary_property is nil' do
      it 'returns nil' do
        expect(loan.primary_property).to be_nil
      end
    end

    context 'loan has primary_property' do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it 'returns primary_property value' do
        expect(@loan.primary_property).not_to be_nil
      end
    end
  end

  describe '.rental_properties' do
    context 'rental_properties is nil' do
      it 'returns nil' do
        expect(loan.rental_properties).to eq([])
      end
    end

    context 'loan has rental_properties' do
      before(:each) do
        @loan = FactoryGirl.create(:loan_with_properties)
      end

      it 'returns rental_properties value' do
        expect(@loan.rental_properties).not_to be_nil
      end
    end
  end

  describe '.ltv_formula' do
    context 'property or amount is nil' do
      it 'returns nil' do
        expect(loan.ltv_formula).to be_nil
      end
    end

    context 'property and amount are valid' do
      let(:property) { FactoryGirl.create(:subject_property, loan: loan) }

      it 'returns ltv_formula value' do
        expected_value = (loan.amount / property.purchase_price * 100).ceil
        expect(loan.ltv_formula).to eq(expected_value)
      end
    end
  end

  describe '.num_of_years' do
    context 'num_of_months is nil' do
      it 'returns nil' do
        loan.num_of_months = nil
        expect(loan.num_of_years).to be_nil
      end
    end

    context 'num_of_months is a valid number' do
      it 'returns number of years' do
        loan.num_of_months = 24
        expect(loan.num_of_years).to eq(2)
      end
    end
  end

  describe '.purpose_titleize' do
    context 'purpose is nil' do
      it 'returns nil' do
        loan.purpose = nil
        expect(loan.purpose_titleize).to be_nil
      end
    end

    context 'purpose is valid' do
      it 'returns number of years' do
        loan.purpose = 1
        expect(loan.purpose_titleize).to eq('Refinance')
      end
    end
  end

  describe '.relationship_manager' do
    let(:loan_with_loan_member) { FactoryGirl.create(:loan_with_loan_member) }

    context 'loans_members_associations are empty' do
      it 'returns nil if there is not any loans members associations' do
        loan.loans_members_associations = []
        expect(loan.relationship_manager).to be_nil
      end
    end

    context 'non existing relationship manager' do
      it 'returns nil' do
        loan_with_loan_member.loans_members_associations.last.update(title: 'sale')
        expect(loan_with_loan_member.relationship_manager).to be_nil
      end
    end

    context 'loans_members_associations are valid' do
      it 'returns a loan member' do
        loan_with_loan_member.loans_members_associations.last.update(title: 'manager')
        expect(loan_with_loan_member.relationship_manager).to be_a(LoanMember)
      end
    end
  end
end
