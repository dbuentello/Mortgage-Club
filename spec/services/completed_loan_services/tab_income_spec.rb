require "rails_helper"

describe CompletedLoanServices::TabIncome do
  let!(:loan) { FactoryGirl.create(:loan) }

  before(:each) do
    @service = CompletedLoanServices::TabIncome.new({
      borrower: loan.borrower,
      current_employment: loan.borrower.current_employment,
      previous_employment: loan.borrower.previous_employment
    })
  end

  it "returns false with gross income nil" do
    @service.borrower.gross_income = nil
    expect(@service.call).to be_falsey
  end

  it "returns true with duration greater than or equals 2" do
    @service.current_employment.duration = 3
    expect(@service.call).to be_truthy
  end

  it "returns true with duration lest than 2" do
    @service.current_employment.duration = 1
    FactoryGirl.create(:employment, borrower: loan.borrower, is_current: false, monthly_income: 1000)
    @service.previous_employment = loan.borrower.previous_employment
    expect(@service.call).to be_truthy
  end

  describe "#employment_completed?" do
    it "returns false with employer name nil" do
      @service.current_employment.employer_name = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with address nil" do
      @service.current_employment.address = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with employer contact name nil" do
      @service.current_employment.employer_contact_name = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with employer contact number nil" do
      @service.current_employment.employer_contact_number = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with current salary nil" do
      @service.current_employment.current_salary = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with job title nil" do
      @service.current_employment.job_title = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with pay frequency nil" do
      @service.current_employment.pay_frequency = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns false with duration nil" do
      @service.current_employment.duration = nil
      expect(@service.employment_completed?).to be_falsey
    end

    it "returns true with valid values" do
      expect(@service.employment_completed?).to be_truthy
    end
  end

  describe "#current_employment_duration_valid?" do
    it "returns true with duration greater than or equals 2" do
      @service.current_employment.duration = 2
      expect(@service.current_employment_duration_valid?).to be_truthy
    end

    context "with duration less than 2" do
      describe "checks previous employment" do
        before do
          loan.borrower.current_employment.duration = 1
          FactoryGirl.create(:employment, borrower: loan.borrower, is_current: false, monthly_income: 1000)
          @service.previous_employment = loan.borrower.previous_employment
        end

        it "returns false with employer name nil" do
          @service.previous_employment.employer_name = nil
          expect(@service.current_employment_duration_valid?).to be_falsey
        end

        it "returns false with job_title nil" do
          @service.previous_employment.job_title = nil
          expect(@service.current_employment_duration_valid?).to be_falsey
        end

        it "returns false with duration nil" do
          @service.previous_employment.duration = nil
          expect(@service.current_employment_duration_valid?).to be_falsey
        end

        it "returns false with monthly income nil" do
          @service.previous_employment.monthly_income = nil
          expect(@service.current_employment_duration_valid?).to be_falsey
        end

        it "returns true with valid values" do
          expect(@service.current_employment_duration_valid?).to be_truthy
        end
      end
    end
  end
end
