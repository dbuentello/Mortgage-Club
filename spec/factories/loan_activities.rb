# == Schema Information
#
# Table name: loan_activities
#
#  id              :uuid             not null, primary key
#  name            :string
#  activity_type   :integer          default(0), not null
#  activity_status :integer          default(0), not null
#  user_visible    :boolean          default(FALSE), not null
#  loan_id         :uuid
#  loan_member_id  :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  duration        :integer          default(0)
#  start_date      :datetime
#  end_date        :datetime
#

FactoryGirl.define do
  factory :loan_activity do |f|
    loan
    loan_member
    activity_type

    f.name { Faker::Lorem.word }
    f.activity_status { ['start', 'done', 'pause'].sample }
    f.user_visible { [true, false].sample }
    f.duration { 0 }
  end
end
