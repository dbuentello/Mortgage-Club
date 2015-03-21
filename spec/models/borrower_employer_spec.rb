require 'rails_helper'

describe BorrowerEmployer do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:borrower_employer)).to be_valid
  end 
end
