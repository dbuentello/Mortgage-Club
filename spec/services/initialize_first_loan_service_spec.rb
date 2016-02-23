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

    context "with correct primary property" do
      it "creates a new loan" do
        loan = described_class.new(user_has_borrower).call
        primary_property_address = loan.primary_property.address
        borrower_current_address = user_has_borrower.borrower.current_address.address

        expect(loan.primary_property).not_to be_nil

        expect(primary_property_address.street_address).to eq(borrower_current_address.street_address)
        expect(primary_property_address.street_address2).to eq(borrower_current_address.street_address2)
        expect(primary_property_address.zip).to eq(borrower_current_address.zip)
        expect(primary_property_address.state).to eq(borrower_current_address.state)
        expect(primary_property_address.city).to eq(borrower_current_address.city)
        expect(primary_property_address.full_text).to eq(borrower_current_address.full_text)
      end
    end

    context "with borrower nil" do
      it "does not create primary property" do
        user_has_borrower.borrower = nil
        loan = described_class.new(user_has_borrower).call

        expect(loan.primary_property).to be_nil
      end
    end

    context "with borrower current address nil" do
      it "does not create primary property" do
        user_has_borrower.borrower.borrower_addresses.last.update(is_current: false)
        loan = described_class.new(user_has_borrower).call

        expect(loan.primary_property).to be_nil
      end
    end

    context "with address of borrower current address nil" do
      it "does not create primary property" do
        user_has_borrower.borrower.current_address.address = nil
        loan = described_class.new(user_has_borrower).call

        expect(loan.primary_property).to be_nil
      end
    end
  end
end
