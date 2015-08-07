require 'rails_helper'

describe LoanActivityServices::CalculateProcessingTime do
  let(:loan_activity) { FactoryGirl.create(:loan_activity) }

  it "returns true with valid params" do
    result = LoanActivityServices::CalculateProcessingTime.new(loan_activity, "start").call
    expect(result).to eq(true)
  end

  describe ".start_switcher" do
    before(:each) { @previous_activity_status = "start" }

    context "when current_activity_status is start" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "start" # current_activity_status
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_activity_status).call
      end

      it "sets started_at to Time now" do
        expect(loan_activity.started_at).to eq(Time.now)
      end

      it "sets duration to 0" do
        expect(loan_activity.duration).to eq(0)
      end
    end

    context "when current_activity_status is pause or done" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "pause" # current_activity_status
        loan_activity.started_at = Time.now
        @current_time = Time.now
        @next_time = Time.now + 1.hour
      end

      it "sets started_at to nil" do
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_activity_status).call
        expect(loan_activity.started_at).to be_nil
      end

      it "updates duration with exactly value" do
        Timecop.travel(@next_time)
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_activity_status).call
        expect(loan_activity.duration).to eq(@next_time - @current_time)
      end
    end
  end

  describe ".pause_switcher" do
    before(:each) { @previous_activity_status = "pause" }

    context "when current_activity_status is start" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "start" # current_activity_status
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_activity_status).call
      end

      it "sets started_at to Time now" do
        expect(loan_activity.started_at).to eq(Time.now)
      end
    end

    context "when current_activity_status is done" do
      it "will do something in the future"
    end
  end

  describe ".done_switcher" do
    before(:each) { @previous_activity_status = "done" }

    context "when current_activity_status is done" do
      before(:each) do
        Timecop.freeze
        loan_activity.activity_status = "done" # current_activity_status
        LoanActivityServices::CalculateProcessingTime.new(loan_activity, @previous_activity_status).call
      end

      it "sets started_at to Time now" do
        expect(loan_activity.started_at).to eq(Time.now)
      end
    end
  end
end