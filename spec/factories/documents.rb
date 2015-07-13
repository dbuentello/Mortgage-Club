FactoryGirl.define do
  factory :document do |f|
    f.type { ['BankStatement', 'BrokerageStatement', 'Paystub', 'W2'].sample }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end

  factory :bank_statement, parent: :document do |f|
    f.type 'BankStatement'
  end

  factory :brokerage_statement, parent: :document do |f|
    f.type 'BrokerageStatement'
  end

  factory :paystub, parent: :document do |f|
    f.type 'Paystub'
  end

  factory :w2, parent: :document do |f|
    f.type 'W2'
  end
end
