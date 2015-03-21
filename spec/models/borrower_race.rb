require 'rails_helper'

describe BorrowerRace do 
  it 'has a valid factory' do 
    expect(FactoryGirl.create(:borrower_race)).to be_valid
  end 
end
