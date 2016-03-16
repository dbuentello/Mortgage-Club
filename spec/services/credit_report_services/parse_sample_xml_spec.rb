require "rails_helper"

describe CreditReportServices::ParseSampleXml do
  let(:borrower) { FactoryGirl.create(:borrower) }

  it "does not create a duplicate liability" do
    CreditReportServices::ParseSampleXml.call(borrower)
    expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { Liability.count }.by(0)
  end

  it "creates new liabilities" do
    expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { Liability.count }.by(8)
  end

  it "returns liabilities" do
    expect(CreditReportServices::ParseSampleXml.call(borrower)).not_to be_empty
  end

  it "updates score for credit report" do
    CreditReportServices::ParseSampleXml.call(borrower)
    expect(CreditReport.last.score).not_to be_nil
  end

  context "with existent credit_report" do
    let!(:credit_report) { FactoryGirl.create(:credit_report, borrower: borrower) }

    it "does not create a new credit report" do
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { CreditReport.count }.by(0)
    end
  end

  context "with non-existent credit_report" do
    it "creates a new credit report" do
      expect { CreditReportServices::ParseSampleXml.call(borrower) }.to change { CreditReport.count }.by(1)
    end
  end

  describe ".get_liability_attributes" do
    it "returns a hash containing liability's attributes" do
      doc = CreditReportServices::ParseSampleXml.read_file
      credit_liability = doc.css('CREDIT_LIABILITY').first
      attributes = CreditReportServices::ParseSampleXml.get_liability_attributes(credit_liability)

      expect(attributes).to include(:account_type, :payment, :balance, :phone, :name)
    end
  end

  describe ".get_address_attributes" do
    it "returns a hash containing address's attributes" do
      doc = CreditReportServices::ParseSampleXml.read_file
      credit_liability = doc.css('CREDIT_LIABILITY').first
      attributes = CreditReportServices::ParseSampleXml.get_address_attributes(credit_liability)

      expect(attributes).to include(:street_address, :city, :state, :zip)
    end
  end

  describe ".get_credit_score" do
    it "returns a credit score" do
      doc = CreditReportServices::ParseSampleXml.read_file
      expect(CreditReportServices::ParseSampleXml.get_credit_score(doc)).to be_a(Float)
    end
  end

  describe ".duplicate?" do
    let(:credit_report) { FactoryGirl.create(:credit_report, borrower: borrower) }
    before(:each) { @credit_liability = credit_report.liabilities.first }

    context "with non duplicate liability" do
      it "returns false" do
        credit_report.liabilities = []
        expect(
          CreditReportServices::ParseSampleXml.duplicate?(credit_report, @credit_liability)
        ).to be_falsey
      end
    end

    context "with duplicate liability" do
      it "returns true" do
        credit_report.reload
        expect(
          CreditReportServices::ParseSampleXml.duplicate?(credit_report, @credit_liability)
        ).to be_truthy
      end
    end
  end
end
