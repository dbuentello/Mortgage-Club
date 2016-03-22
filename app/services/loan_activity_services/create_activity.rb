module LoanActivityServices
  class CreateActivity
    attr_accessor :error_message

    def call(loan_member, activity_params)
      activity_params[:loan_member_id] = loan_member.id
      @loan_activity = LoanActivity.new(activity_params)
      previous_loan_activity = LoanActivity.get_latest_by_loan_and_name(
        activity_params[:loan_id], activity_params[:name]
      )

      if @loan_activity.save
        CalculateProcessingTime.new(@loan_activity, previous_loan_activity).call if previous_loan_activity
        SetUserVisibleToFalse.call(@loan_activity.loan, @loan_activity.name) unless @loan_activity.user_visible
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
