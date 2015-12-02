# == Schema Information
#
# Table name: lender_templates
#
#  id                         :uuid             not null, primary key
#  name                       :string
#  description                :string
#  lender_id                  :uuid

class LenderTemplate < ActiveRecord::Base
  belongs_to :lender

  validates :name, presence: true

  PERMITTED_ATTRS = [:name, :description]
end
