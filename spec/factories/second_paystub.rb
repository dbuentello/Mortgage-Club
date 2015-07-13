FactoryGirl.define do
  factory :second_paystub, :class => Documents::SecondPaystub do |f|
    f.type { 'SecondPaystub' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
