# == Schema Information
#
# Table name: team_members
#
#  id           :integer          not null, primary key
#  first_name   :string
#  last_name    :string
#  middle_name  :string
#  phone_number :string
#  skype_handle :string
#  email        :string
#  employee_id  :integer
#  nmls_id      :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TeamMember < ActiveRecord::Base
  belongs_to :user

end
