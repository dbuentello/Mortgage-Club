# == Schema Information
#
# Table name: loan_activities
#
#  id              :uuid             not null, primary key
#  name            :string
#  activity_type   :integer          default(0), not null
#  activity_status :integer          default(0), not null
#  user_visible    :boolean          default(FALSE), not null
#  loan_id         :uuid
#  loan_member_id  :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  duration        :integer          default(0)
#

class LoanActivity < ActiveRecord::Base
  scope :recent_loan_activities, -> (limit_num) { where(user_visible: true).order(created_at: :desc).limit(limit_num) }

  LIST = {
    "Prior to Loan Submission" => ["Verify borrower's income", "Verify borrower's down payment", "Verify borrower's rental properties", "Other"],
    "Prior to Loan Docs" => ["Verify borrower's employment", "Ask borrower to submit additional documents"],
    "Prior to Closing" => ["Order preliminary title report", "Schedule notary appointment"],
    "Post Closing" => ["Review loan criteria per lender request"]
  }

  belongs_to :loan
  belongs_to :loan_member

  enum activity_type: {
    loan_submission: 0,
    loan_doc: 1,
    closing: 2,
    post_closing: 3
  }

  enum activity_status: {
    start: 0,
    done: 1,
    pause: 2
  }

  validates_presence_of :loan, :loan_member
  validates_inclusion_of :user_visible, in: [true, false]

  def self.get_latest_by_loan_and_name(loan_id, name)
    return nil if loan_id.nil? || name.nil?

    where(loan_id: loan_id, name: name).last
  end

  def self.get_latest_by_loan(loan)
    return nil if loan.nil?

    loan.loan_activities.find_by_sql("SELECT DISTINCT ON (name)
      l.*, d.duration
      FROM loan_activities l
        LEFT JOIN (
          SELECT name, SUM (duration) as duration
          FROM loan_activities
          GROUP BY name
        ) d ON ( l.name = d.name )
      ORDER BY name, created_at DESC, id")
  end

  def self.get_latest_by_loan_and_conditions(params)
    return nil if params.blank?

    self.find_by_sql("SELECT DISTINCT ON (name)
      l.*, d.duration
      FROM loan_activities l
        LEFT JOIN (
          SELECT name, SUM (duration) as duration
          FROM loan_activities
          GROUP BY name
        ) d ON ( l.name = d.name )
      WHERE
        l.loan_id = '#{params[:loan_id]}'
        AND
        l.activity_type = #{params[:activity_type]}
      ORDER BY name, created_at DESC, id")
  end

  def pretty_activity_type
    case activity_type
    when 'loan_submission'
      LIST.keys[0]
    when 'loan_doc'
      LIST.keys[1]
    when 'closing'
      LIST.keys[2]
    when 'post_closing'
      LIST.keys[3]
    end
  end

  def pretty_activity_status
    case activity_status
    when 'done'
      'done'
    when 'pause'
      'paused'
    when 'start'
      'started'
    end
  end

  def pretty_user_visible
    user_visible.to_s
  end

  def pretty_loan_member_name
    loan_member.user.to_s
  end

  def pretty_duration
    duration ||= 0

    ActionController::Base.helpers.distance_of_time_in_words(0, duration, include_seconds: true)
  end

  def pretty_updated_at
    ActionController::Base.helpers.time_ago_in_words(updated_at)
  end

  def as_json(opts={})
    more_options = {
      methods: [
        :pretty_activity_type, :pretty_activity_status,
        :pretty_user_visible, :pretty_loan_member_name
      ]
    }
    more_options.merge!(opts)

    super(more_options)
  end
end
