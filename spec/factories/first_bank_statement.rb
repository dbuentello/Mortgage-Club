FactoryGirl.define do
  factory :first_bank_statement, :class => Documents::FirstBankStatement do |f|
    f.type { 'Documents::FirstBankStatement' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
