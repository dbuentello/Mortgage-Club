module Documentation
  extend ActiveSupport::Concern

  def file_icon_url
    case attachment_content_type
    when *IMAGE_MINE_TYPES
      if Rails.env.test?
        icon_name = attachment.url
      else
        icon_name = Amazon::GetUrlService.new(attachment.s3_object, 10).call
      end
    when *PDF_MINE_TYPES
      icon_name = 'pdf_icon.png'
    when *MWORD_MINE_TYPES
      icon_name = 'word_icon.png'
    when *EXCEL_MINE_TYPES
      icon_name = 'excel_icon.png'
    when *POWERPOINT_MINE_TYPES
      icon_name = 'powerpoint_icon.png'
    else
      icon_name = 'undefined_icon.png'
    end
    ActionController::Base.helpers.asset_path(icon_name)
  end

  def class_name
    self.class.name
  end

  def owner_name
    return "Mortgage Club" if self.owner.loan_member?
    self.owner.to_s
  end

  def set_description
    return unless description.blank?
    self.description = type.constantize::DESCRIPTION
  end

  def other_report?
    return true if type =~ /^Other/
    false
  end
end