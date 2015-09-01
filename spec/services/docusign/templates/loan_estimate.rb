require 'rails_helper'

describe Docusign::Templates::LoanEstimate do
  let(:loan) { FactoryGirl.create(:loan_with_property) }

  it 'returns a valid structure' do
    allow(loan).to receive(:insurance_binder).and_return(2000)
    allow(loan).to receive(:estimated_cash_to_close).and_return(5000)
    allow(loan).to receive(:estimated_closing_costs).and_return(6000)

    valid_hash = Docusign::Templates::LoanEstimate.new(loan).params
    byebug
    expect(valid_hash).to match_response_schema("loan_estimate_template")
  end
end
