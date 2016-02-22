require "rails_helper"

describe InitializeFirstLoanService do
  let(:user) { FactoryGirl.create(:user) }

  context "when quote_cookies is present" do
    before(:each) do
      @quote_cookies = {
        mortgage_purpose: "purchase",
        property_type: "sfh",
        property_usage: "primary_residence",
        property_value: 400000
      }.to_json
    end

    it "creates a new loan" do
      expect { described_class.new(user, @quote_cookies).call }.to change{Loan.count}.by(1)
    end

    it "creates a new loan with cookies's data" do
      loan = described_class.new(user, @quote_cookies).call

      expect(loan.purpose).to eq("purchase")
      expect(loan.subject_property.purchase_price).to eq(400000)
      expect(loan.subject_property.property_type).to eq("sfh")
      expect(loan.subject_property.usage).to eq("primary_residence")
    end
  end

  context "when quote_cookies is nil" do
    it "creates a new loan" do
      expect { described_class.new(user, nil).call }.to change{Loan.count}.by(1)
    end

    it "creates a new loan without cookies's data" do
      loan = described_class.new(user, @quote_cookies).call

      expect(loan.purpose).to be_nil
      expect(loan.subject_property.purchase_price).to be_nil
      expect(loan.subject_property.property_type).to be_nil
      expect(loan.subject_property.usage).to be_nil
    end
  end

  context "when creating new loan with primary property" do
    let!(:user_has_borrower) { FactoryGirl.create(:user_has_borrower) }

    before(:each) do
      user_has_borrower.borrower.borrower_addresses.find_by(is_current: true).update(is_rental: false)
    end

    it "creates a new loan" do
      expect { described_class.new(user_has_borrower).call }.to change{Loan.count}.by(1)
    end

    it "creates a new loan with correct primary property" do
      loan = described_class.new(user_has_borrower).call
      expect(loan.primary_property).not_to be_nil
    end

    it "not create primary property with borrower nil" do
      user_has_borrower.borrower = nil
      loan = described_class.new(user_has_borrower).call

      expect(loan.primary_property).to be_nil
    end

    it "not create primary property with borrower current address nil" do
      user_has_borrower.borrower.borrower_addresses.last.update(is_current: false)
      loan = described_class.new(user_has_borrower).call

      expect(loan.primary_property).to be_nil
    end

    it "not create primary property with address of borrower current address nil" do
      user_has_borrower.borrower.current_address.address = nil
      loan = described_class.new(user_has_borrower).call

      expect(loan.primary_property).to be_nil
    end
  end
end
