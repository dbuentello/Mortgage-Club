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

FactoryGirl.define do
  factory :borrower_document do |f|
    f.type { ['FirstW2', 'SecondW2', 'FirstPaystub',
      'SecondPaystub', 'FirstBankStatement',
      'SecondBankStatement'].sample }

    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')

    factory :first_w2, class: 'FirstW2' do
      type { 'FirstW2' }
    end

    factory :second_w2 , class: 'SecondW2'do
      type { 'SecondW2' }
    end

    factory :first_paystub, class: 'FirstPaystub' do
      type { 'FirstPaystub' }
    end

    factory :second_paystub, class: 'SecondPaystub' do
      type { 'SecondPaystub' }
    end

    factory :first_bank_statement, class: 'FirstBankStatement' do
      type { 'FirstBankStatement' }
    end

    factory :second_bank_statement, class: 'SecondBankStatement' do
      type { 'SecondBankStatement' }
    end
  end
end
