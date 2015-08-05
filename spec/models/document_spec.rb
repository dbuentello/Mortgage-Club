require 'rails_helper'

describe Document do
  it 'has valid factories' do
    expect(FactoryGirl.build(:document)).to be_valid
    expect(FactoryGirl.build(:first_w2)).to be_valid
    expect(FactoryGirl.build(:second_w2)).to be_valid
    expect(FactoryGirl.build(:first_paystub)).to be_valid
    expect(FactoryGirl.build(:second_paystub)).to be_valid
    expect(FactoryGirl.build(:first_bank_statement)).to be_valid
    expect(FactoryGirl.build(:second_bank_statement)).to be_valid
  end
end
