module Documentation
  extend ActiveSupport::Concern

  def file_icon_url
    case attachment_content_type
    when *JPG_MINE_TYPES
      icon_name = 'jpg_icon.png'
    when *PNG_MINE_TYPES
      icon_name = 'png_icon.png'
    when *GIF_MINE_TYPES
      icon_name = 'gif_icon.png'
    when *TIFF_MINE_TYPES
      icon_name = 'tiff_icon.png'
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
    "#{owner.first_name} #{owner.last_name}"
  end

  def set_description
    return if description.present?
    self.description = type.constantize::DESCRIPTION
  end

  def other_report?
    return true if type =~ /^Other/
    false
  end
end
