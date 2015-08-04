require 'rails_helper'

describe PropertyDocument do
  it 'has valid factories' do
    expect(FactoryGirl.create(:property_document)).to be_valid
    expect(FactoryGirl.create(:appraisal_report)).to be_valid
    expect(FactoryGirl.create(:homeowners_insurance)).to be_valid
    expect(FactoryGirl.create(:mortgage_statement)).to be_valid
    expect(FactoryGirl.create(:lease_agreement)).to be_valid
    expect(FactoryGirl.create(:purchase_agreement)).to be_valid
    expect(FactoryGirl.create(:flood_zone_certification)).to be_valid
    expect(FactoryGirl.create(:termite_report)).to be_valid
    expect(FactoryGirl.create(:inspection_report)).to be_valid
    expect(FactoryGirl.create(:title_report)).to be_valid
    expect(FactoryGirl.create(:risk_report)).to be_valid
  end
end
