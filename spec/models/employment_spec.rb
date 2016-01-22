require 'rails_helper'

describe Employment do
  let(:employment) { FactoryGirl.build(:employment) }

  it 'has a valid factory' do
    expect(employment).to be_valid
  end

  it 'has a valid factory with address object' do
    expect(employment.address).to be_truthy
  end

  describe 'raises error when current_salary exceeds maximum allowed value' do
    let(:employment) { FactoryGirl.build(:employment, current_salary: 123123123123) }
    it "raises StatementInvalid Error" do
      expect { employment.save }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
