require 'rails_helper'

describe PropertyDocument do
  it 'has valid factories' do
    expect(FactoryGirl.build(:property_document)).to be_valid
    expect(FactoryGirl.build(:appraisal_report)).to be_valid
    expect(FactoryGirl.build(:homeowners_insurance)).to be_valid
    expect(FactoryGirl.build(:mortgage_statement)).to be_valid
    expect(FactoryGirl.build(:lease_agreement)).to be_valid
    expect(FactoryGirl.build(:purchase_agreement)).to be_valid
    expect(FactoryGirl.build(:flood_zone_certification)).to be_valid
    expect(FactoryGirl.build(:termite_report)).to be_valid
    expect(FactoryGirl.build(:inspection_report)).to be_valid
    expect(FactoryGirl.build(:title_report)).to be_valid
    expect(FactoryGirl.build(:risk_report)).to be_valid
    expect(FactoryGirl.build(:other_property_report)).to be_valid
  end
end
