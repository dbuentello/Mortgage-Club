FactoryGirl.define do
  factory :second_w2, :class => Documents::SecondW2 do |f|
    f.type { 'Documents::SecondW2' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
