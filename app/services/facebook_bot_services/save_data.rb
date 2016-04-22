module FacebookBotServices
  class SaveData
    def self.call(params)
      return unless params && params[:conversation_id].present? && params[:parameters].present? &&
                    params[:profile].present? && params[:profile].present?

      facebook_data = FacebookData.find_or_initialize_by(conversation_id: params[:conversation_id])
      facebook_data.first_name = params[:profile][:first_name]
      facebook_data.last_name = params[:profile][:last_name]
      facebook_data.profile_pic = params[:profile][:profile_pic]
      facebook_data.facebook_id = params[:profile][:facebook_id]
      facebook_data.purpose = params[:parameters][:purpose]
      facebook_data.down_payment = params[:parameters][:down_payment].to_f
      facebook_data.property_value = params[:parameters][:property_value].to_f
      facebook_data.property_type = params[:parameters][:property_type]
      facebook_data.usage = params[:parameters][:usage]
      facebook_data.zipcode = params[:parameters][:zipcode]
      facebook_data.mortgage_balance = params[:parameters][:mortgage_balance].to_f
      facebook_data.credit_score = params[:parameters][:credit_score]
      facebook_data.resolved_queries = params[:resolved_queries]
      facebook_data.save
    end
  end
end
