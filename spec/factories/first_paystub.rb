FactoryGirl.define do
  factory :first_paystub, :class => Documents::FirstPaystub do |f|
    f.type { 'Documents::FirstPaystub' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
