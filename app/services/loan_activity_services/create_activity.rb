module LoanActivityServices
  class CreateActivity
    attr_accessor :error_message

    def call(loan_member, activity_params)
      @loan_activity = LoanActivity.find_or_initialize_by(
        loan_id: activity_params[:loan_id], name: activity_params[:name]
      )
      previous_activity_status = @loan_activity.activity_status # must be set right now

      # set loan member
      activity_params[:loan_member_id] = loan_member.id

      # set other attributes
      @loan_activity.attributes = activity_params
      if @loan_activity.save
        CalculateProcessingTime.new(@loan_activity, previous_activity_status).call
      else
        @error_message = @loan_activity.errors.full_messages.join(". ")
      end

      self
    end

    def success?
      @loan_activity.valid?
    end
  end
end