module LoanActivityServices
  class CalculateProcessingTime
    def initialize(loan_activity, previous_activity_status = "start")
      @loan_activity = loan_activity
      @previous_activity_status = previous_activity_status
      @current_activity_status = loan_activity.activity_status
    end

    def call
      case @previous_activity_status
      when "start"
        start_switcher
      when "pause"
        pause_switcher
      when "done"
        done_switcher
      end

      @loan_activity.save
    end

    private

    def start_switcher
      case @current_activity_status
      when "start"
        # nil to start
        @loan_activity.started_at = Time.now
        @loan_activity.duration = 0
      when "pause", "done"
        # start to pause/done
        @loan_activity.duration += Time.now - @loan_activity.started_at.to_time
        @loan_activity.started_at = nil
      end
    end

    def pause_switcher
      case @current_activity_status
      when "start"
        # pause to start
        @loan_activity.started_at = Time.now
      when "done"
        # pause to done
        # push Done notification
      end
    end

    def done_switcher
      # done to start
      @loan_activity.started_at = Time.now
    end

  end
end