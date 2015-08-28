module LoanActivityServices
  class CalculateProcessingTime
    def initialize(new_activity, old_activity)
      @old_activity = old_activity

      @old_activity_status = old_activity.activity_status
      @new_activity_status = new_activity.activity_status
    end

    def call
      case @old_activity_status
      when "start"
        start_switcher
      when "pause"
        pause_switcher
      when "done"
        done_switcher
      end

      @old_activity.save
    end

    private

    def start_switcher
      case @new_activity_status
      when "start"
        # nil to start
      when "pause", "done"
        # start to pause/done
        @old_activity.duration = Time.now.utc - @old_activity.created_at.in_time_zone
      end
    end

    def pause_switcher
      case @new_activity_status
      when "start"
        # pause to start
      when "done"
        # pause to done
      end
    end

    def done_switcher
      # done to start
    end

  end
end