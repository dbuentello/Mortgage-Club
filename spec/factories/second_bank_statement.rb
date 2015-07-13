FactoryGirl.define do
  factory :second_bank_statement, :class => Documents::SecondBankStatement do |f|
    f.type { 'SecondBankStatement' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
