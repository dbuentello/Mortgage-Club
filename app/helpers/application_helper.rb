module ApplicationHelper
  def dev_infographics_page?
    request[:controller] == "pages" && request[:action] == "developer_infographics"
  end

  def find_root_path
    return unauthenticated_root_path unless current_user
    return admin_root_path if current_user.has_role?(:admin)
    return loan_member_root_path if current_user.has_role?(:lender_member)
    borrower_root_path
  end

  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      nil # don't accept other types
    end
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      if (bootstrap_class = bootstrap_class_for(msg_type)).present?
        concat(content_tag(:div, message, class: "alert #{bootstrap_class} fade in") do
          concat content_tag(:button, 'x', class: "close", data: {dismiss: 'alert'})
          concat message
        end)
      end
    end
    nil
  end

  def flash_messages_content(opts={})
    flash[:alert]
  end
end
