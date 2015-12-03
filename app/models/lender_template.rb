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

  def self.create_other_template(lender)
    template = self.find_or_initialize_by(name: "Other Document", description: "This is an other form", is_other: true)
    requirement = template.lender_template_requirements.find_or_initialize_by(lender: lender)
    requirement.save
  end
end
