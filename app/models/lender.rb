# == Schema Information
#
# Table name: lenders
#
#  id                         :uuid             not null, primary key
#  name                       :string
#  website                    :string
#  rate_sheet                 :string
#  lock_rate_email            :string
#  docs_email                 :string
#  contact_email              :string
#  contact_name               :string
#  contact_phone              :string

class Lender < ActiveRecord::Base
  validates :name, presence: true

  has_many :templates, class_name: 'LenderTemplate', dependent: :destroy

  PERMITTED_ATTRS = [
    :name,
    :website,
    :rate_sheet,
    :lock_rate_email,
    :docs_email,
    :contact_email,
    :contact_name,
    :contact_phone
  ]
end
