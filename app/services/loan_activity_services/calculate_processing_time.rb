# calculate processing time of loan member's activities
module LoanActivityServices
  class CalculateProcessingTime
    attr_accessor :old_activity, :new_activity, :old_activity_status, :new_activity_status

    def initialize(new_activity, old_activity)
      @old_activity = old_activity
      @new_activity = new_activity
      @old_activity_status = old_activity.activity_status
      @new_activity_status = new_activity.activity_status
    end

    def call
      case old_activity_status
      when "start"
        start_switcher
      when "pause"
        pause_switcher
      when "done"
        done_switcher
      end

      old_activity.save && new_activity.save
    end

    private

    def start_switcher
      case new_activity_status
      when "start"
        # do something
      when "pause"
        # start to pause
        old_activity.duration = Time.now.utc - old_activity.created_at.in_time_zone
        old_activity.end_date = Time.zone.now
      when "done"
        # start to done
        old_activity.duration = Time.now.utc - old_activity.created_at.in_time_zone
        old_activity.end_date = Time.zone.now
        new_activity.end_date = Time.zone.now
      end
      new_activity.start_date = old_activity.start_date
    end

    def pause_switcher
      case new_activity_status
      when "start"
        # pause to start
        old_activity.end_date = Time.zone.now
      when "done"
        # pause to done
        old_activity.end_date = Time.zone.now
        new_activity.end_date = Time.zone.now
      end
      new_activity.start_date = old_activity.start_date
    end

    def done_switcher
      # done to start
      old_activity.end_date = Time.zone.now
      new_activity.start_date = Time.zone.now
    end
  end
end
