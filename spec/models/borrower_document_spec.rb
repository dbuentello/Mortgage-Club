# == Schema Information
#
# Table name: documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  description             :string
#

require 'rails_helper'

describe BorrowerDocument do
  it 'has valid factories' do
    expect(FactoryGirl.build(:borrower_document)).to be_valid
    expect(FactoryGirl.build(:first_w2)).to be_valid
    expect(FactoryGirl.build(:second_w2)).to be_valid
    expect(FactoryGirl.build(:first_paystub)).to be_valid
    expect(FactoryGirl.build(:second_paystub)).to be_valid
    expect(FactoryGirl.build(:first_bank_statement)).to be_valid
    expect(FactoryGirl.build(:second_bank_statement)).to be_valid
  end
end
