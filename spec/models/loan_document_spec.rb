require 'rails_helper'

describe LoanDocument do
  it 'has valid factories' do
    expect(FactoryGirl.build(:loan_document)).to be_valid
    expect(FactoryGirl.build(:hud_estimate)).to be_valid
    expect(FactoryGirl.build(:hud_final)).to be_valid
    expect(FactoryGirl.build(:loan_estimate)).to be_valid
    expect(FactoryGirl.build(:uniform_residential_lending_application)).to be_valid
  end
end
