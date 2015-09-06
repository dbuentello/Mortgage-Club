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

  validates :name, :docusign_id, :state, presence: true
  validates :name, uniqueness: true

  after_save :clear_cache

  # clear cache for Docusign tabs
  def clear_cache
    begin
      $redis.del name if $redis.get(name)
    rescue Exception => e
      Rails.logger.error(e)
    end
  end

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
end
