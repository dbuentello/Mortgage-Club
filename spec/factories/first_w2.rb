FactoryGirl.define do
  factory :first_w2, :class => Documents::FirstW2 do |f|
    f.type { 'FirstW2' }
    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
  end
end
