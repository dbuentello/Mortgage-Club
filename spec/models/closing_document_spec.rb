require 'rails_helper'

describe ClosingDocument do
  it 'has valid factories' do
    expect(FactoryGirl.build(:closing_document)).to be_valid
    expect(FactoryGirl.build(:closing_disclosure)).to be_valid
    expect(FactoryGirl.build(:deed_of_trust)).to be_valid
    expect(FactoryGirl.build(:other_closing_report)).to be_valid
  end
end
