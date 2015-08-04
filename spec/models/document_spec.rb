require 'rails_helper'

describe Document do
  it 'has valid factories' do
    expect(FactoryGirl.create(:document)).to be_valid
    expect(FactoryGirl.create(:first_w2)).to be_valid
    expect(FactoryGirl.create(:second_w2)).to be_valid
    expect(FactoryGirl.create(:first_paystub)).to be_valid
    expect(FactoryGirl.create(:second_paystub)).to be_valid
    expect(FactoryGirl.create(:first_bank_statement)).to be_valid
    expect(FactoryGirl.create(:second_bank_statement)).to be_valid
  end
end
