require "rails_helper"

describe CompletedLoanServices::TabProperty do
  let!(:loan) { FactoryGirl.create(:loan) }
  let!(:property) { FactoryGirl.create(:subject_property, loan: loan, usage: 0) }
  let!(:address) { FactoryGirl.create(:address, property: property) }
  let(:service) { CompletedLoanServices::TabProperty.new(loan, property) }

  it "returns false with subject property nil" do
    service.subject_property = nil
    expect(service.call).to be_falsey
  end

  it "returns true with purpose purchase" do
    service.loan.purpose = "purchase"
    service.subject_property.purchase_price = 1000

    expect(service.call).to be_truthy
  end

  it "returns true with purpose refinance" do
    service.loan.purpose = "refinance"
    service.subject_property.original_purchase_price = 100
    service.subject_property.original_purchase_year = 10

    expect(service.call).to be_truthy
  end

  describe "#subject_property_completed" do
    # it "returns false with property type nil" do
    #   service.subject_property.property_type = nil
    #   expect(service.subject_property_completed?).to be_falsey
    # end

    it "returns false with address nil" do
      service.subject_property.address = nil
      expect(service.subject_property_completed?).to be_falsey
    end

    it "returns false with usage nil" do
      service.subject_property.usage = nil
      expect(service.subject_property_completed?).to be_falsey
    end

    it "returns true with valid values" do
      expect(service.subject_property_completed?).to be_truthy
    end
  end

  describe "#address_completed?" do
    it "returns false with all empty fields" do
      service.subject_property.address.street_address = nil
      service.subject_property.address.street_address2 = nil
      service.subject_property.address.city = nil
      service.subject_property.address.state = nil
      service.subject_property.address.zip = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with street address nil" do
      service.subject_property.address.street_address = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with zip nil" do
      service.subject_property.address.zip = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with state nil" do
      service.subject_property.address.state = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with city nil" do
      service.subject_property.address.city = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with street address nil" do
      service.subject_property.address.street_address = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns false with full text nil" do
      service.subject_property.address.full_text = nil

      expect(service.address_completed?).to be_falsey
    end

    it "returns true with valid values" do
      expect(service.address_completed?).to be_truthy
    end
  end

  describe "#purpose_completed?" do
    it "returns false with purpose nil" do
      service.loan.purpose = nil

      expect(service.purpose_completed?).to be_falsey
    end

    context "with loan purchase" do
      it "returns false with purchase price nil" do
        service.loan.purpose = "purchase"
        service.subject_property.purchase_price = nil

        expect(service.purpose_completed?).to be_falsey
      end

      it "returns true with valid purchase price" do
        service.loan.purpose = "purchase"

        expect(service.purpose_completed?).to be_truthy
      end
    end

    context "with loan refinance" do
      it "returns false with purchase price nil" do
        service.loan.purpose = "refinance"
        service.subject_property.original_purchase_price = nil

        expect(service.purpose_completed?).to be_falsey
      end

      it "returns false with purchase year nil" do
        service.loan.purpose = "refinance"
        service.subject_property.original_purchase_year = nil

        expect(service.purpose_completed?).to be_falsey
      end

      it "returns true with valid values" do
        service.loan.purpose = "refinance"
        service.subject_property.original_purchase_price = 100
        service.subject_property.original_purchase_year = 10

        expect(service.purpose_completed?).to be_truthy
      end
    end
  end
end
