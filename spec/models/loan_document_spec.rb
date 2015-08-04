require 'rails_helper'

describe LoanDocument do
  it 'has valid factories' do
    expect(FactoryGirl.create(:loan_document)).to be_valid
    expect(FactoryGirl.create(:hud_estimate)).to be_valid
    expect(FactoryGirl.create(:hud_final)).to be_valid
    expect(FactoryGirl.create(:loan_estimate)).to be_valid
    expect(FactoryGirl.create(:uniform_residential_lending_application)).to be_valid
  end
end
