# == Schema Information
#
# Table name: lender_templates
#
#  id                         :uuid             not null, primary key
#  name                       :string
#  description                :string

class LenderTemplate < ActiveRecord::Base
  validates :name, presence: true

  has_many :lender_template_requirements, dependent: :destroy
  has_many :lenders, through: :lender_template_requirements

  PERMITTED_ATTRS = [:name, :description]
end
