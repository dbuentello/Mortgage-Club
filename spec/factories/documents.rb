FactoryGirl.define do
  factory :document do |f|
    f.type { ['Documents::FirstW2', 'Documents::SecondW2', 'Documents::FirstPaystub',
      'Documents::SecondPaystub', 'Documents::FirstBankStatement',
      'Documents::SecondBankStatement'].sample }

    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')

    factory :first_w2, class: 'Documents::FirstW2' do
      type { 'Documents::FirstW2' }
    end

    factory :second_w2 , class: 'Documents::SecondW2'do
      type { 'Documents::SecondW2' }
    end

    factory :first_paystub, class: 'Documents::FirstPaystub' do
      type { 'Documents::FirstPaystub' }
    end

    factory :second_paystub, class: 'Documents::SecondPaystub' do
      type { 'Documents::SecondPaystub' }
    end

    factory :first_bank_statement, class: 'Documents::FirstBankStatement' do
      type { 'Documents::FirstBankStatement' }
    end

    factory :second_bank_statement, class: 'Documents::SecondBankStatement' do
      type { 'Documents::SecondBankStatement' }
    end
  end
end
