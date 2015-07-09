module ApplicationHelper
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
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message
        end)
      end
    end
    nil
  end
end
