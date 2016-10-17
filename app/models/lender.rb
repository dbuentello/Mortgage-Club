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
#  nmls                       :string
#  appraisal_fee              :decimal
#  tax_certification_fee      :decimal
#  flood_certification_fee    :decimal
#  logo                       :attachment

class Lender < ActiveRecord::Base
  has_many :lender_template_requirements, dependent: :destroy
  has_many :lender_templates, through: :lender_template_requirements
  has_many :loans
  has_attached_file :logo, path: PAPERCLIP[:default_upload_path], s3_server_side_encryption: 'AES256'

  validates :name, presence: true
  validates :website, presence: true
  validates :rate_sheet, presence: true
  validates :nmls, presence: true

  validates :lock_rate_email,
    presence: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

  validates :docs_email,
    presence: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

  validates :contact_email,
    presence: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validates_attachment :logo,
    presence: true,
    content_type: {
      content_type: /\Aimage\/.*\Z/
    },
    size: {
      less_than_or_equal_to: 2.megabytes,
      message: :size_too_large
    }

  after_save :create_other_lender_template

  PERMITTED_ATTRS = [
    :name,
    :website,
    :rate_sheet,
    :lock_rate_email,
    :docs_email,
    :contact_email,
    :contact_name,
    :contact_phone,
    :nmls,
    :logo,
    :appraisal_fee,
    :tax_certification_fee,
    :flood_certification_fee
  ]
  def logo_url
    logo.url if logo
  end

  def self.dummy_lender
    if lender = Lender.where(name: "Dummy Lender").last
      return lender
    end

    create_dummy_lender
  end

  def self.create_dummy_lender
    Lender.create(
      name: "Dummy Lender",
      website: "dummy.com",
      rate_sheet: "dummy.com/rate_sheet",
      lock_rate_email: "lock@dummy.com",
      docs_email: "docs@dummy.com",
      contact_email: "support@dummy.com",
      contact_name: "John Doe",
      contact_phone: "01-1234-678",
      nmls: "123456789",
      appraisal_fee: 100.0,
      tax_certification_fee: 100.0,
      flood_certification_fee: 100.0,
      logo: File.new("#{Rails.root}/public/mortgageclubLOGO.png")
    )
  end

  private

  def create_other_lender_template
    if lender_templates.empty? || lender_templates.where(is_other: true).nil?
      LenderTemplate.create_other_template(self)
    end
  end
end
