require "rails_helper"

describe CreditReportServices::ParseSampleXml do
  let(:borrower) { FactoryGirl.create(:borrower) }

  context "existent credit_report" do
    before(:each) do
      @credit_report = borrower.create_credit_report(date: Time.zone.today)
    end

    it "credit report not change" do
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { CreditReport.count }.by(0)
    end

    it "shoud increment Liability" do
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { Liability.count }.by(8)
    end

    it "do not insert duplicate liability" do
      CreditReportServices::ParseSampleXml.call(borrower)
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { Liability.count }.by(0)
    end

    it "return not nil" do
      expect(CreditReportServices::ParseSampleXml.call(borrower)).not_to eq(nil)
    end
  end

  context "non-existent credit_report" do
    it "should increment credit_report" do
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { CreditReport.count }.by(1)
    end

    it "do not insert duplicate liability" do
      CreditReportServices::ParseSampleXml.call(borrower)
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { Liability.count }.by(0)
    end
  end
end
