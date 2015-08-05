require 'rails_helper'

describe BorrowerGovernmentMonitoringInfo do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:borrower_government_monitoring_info)).to be_valid
  end
end
