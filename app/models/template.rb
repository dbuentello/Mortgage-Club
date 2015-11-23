# == Schema Information
#
# Table name: templates
#
#  id            :uuid             not null, primary key
#  name          :string
#  state         :string
#  description   :string
#  email_subject :string
#  email_body    :string
#  docusign_id   :string
#  creator_id    :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Template < ActiveRecord::Base
  belongs_to :creator, inverse_of: :templates, class_name: "User", foreign_key: 'creator_id'
  has_many :envelopes, inverse_of: :template
  has_many :lender_templates, dependent: :destroy
  has_many :checklists, dependent: :destroy

  validates :name, :docusign_id, :state, presence: true
  validates :name, uniqueness: true

  def template_mapping
    case name
    when "Loan Estimate"
      Docusign::Templates::LoanEstimate
    when "Servicing Disclosure"
      Docusign::Templates::ServicingDisclosure
    when "Generic Explanation"
      Docusign::Templates::GenericExplanation
    end
  end

  def template_alignment
    case name
    when "Loan Estimate"
      Docusign::Alignment::LoanEstimateService
    when "Servicing Disclosure"
      Docusign::Alignment::ServicingDisclosureService
    when "Generic Explanation"
      Docusign::Alignment::GenericExplanationService
    end
  end

  # TODO: it will be an attribute when we have an interface to CRUD templates.
  def may_need_coapplicant_signature?
    ["Loan Estimate", "Servicing Disclosure"].include? name
  end
end
