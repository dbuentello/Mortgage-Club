require "rails_helper"

describe CompletedLoanServices::TabProperty do
  let!(:loan) { FactoryGirl.create(:loan) }
  let!(:property) { FactoryGirl.create(:subject_property, loan: loan) }
  let!(:address) { FactoryGirl.create(:address, property: property) }

  before(:each) do
    @service = CompletedLoanServices::TabProperty.new(loan, property)
  end

  it "returns false with properties empty" do
    @service.loan.properties = []
    expect(@service.call).to eq(false)
  end

  it "returns false with subject property nil" do
    @service.subject_property = nil
    expect(@service.call).to eq(false)
  end

  it "returns true with purpose purchase" do
    @service.loan.purpose = "purchase"
    @service.subject_property.purchase_price = 1000

    expect(@service.call).to eq(true)
  end

  it "returns true with purpose refinance" do
    @service.loan.purpose = "refinance"
    @service.subject_property.original_purchase_price = 100
    @service.subject_property.original_purchase_year = 10

    expect(@service.call).to eq(true)
  end

  describe "#subject_property_completed" do
    it "returns false with property type nil" do
      @service.subject_property.property_type = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with address nil" do
      @service.subject_property.address = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with usage nil" do
      @service.subject_property.usage = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with market price nil" do
      @service.subject_property.market_price = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with escrows nil" do
      @service.subject_property.mortgage_includes_escrows = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with estimated property tax nil" do
      @service.subject_property.estimated_property_tax = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns false with estimated hazard insurance nil" do
      @service.subject_property.estimated_hazard_insurance = nil
      expect(@service.subject_property_completed?).to eq(false)
    end

    it "returns true with valid values" do
      expect(@service.subject_property_completed?).to eq(true)
    end
  end

  describe "#address_completed?" do
    it "returns false with all empty fields" do
      @service.subject_property.address.street_address = nil
      @service.subject_property.address.street_address2 = nil
      @service.subject_property.address.city = nil
      @service.subject_property.address.state = nil

      expect(@service.address_completed?).to eq(false)
    end

    it "returns false with full text nil" do
      @service.subject_property.address.full_text = nil

      expect(@service.address_completed?).to eq(false)
    end

    it "returns true with valid values" do
      expect(@service.address_completed?).to eq(true)
    end
  end

  describe "#purpose_completed?" do
    it "returns false with purpose nil" do
      @service.loan.purpose = nil

      expect(@service.purpose_completed?).to eq(false)
    end

    context "with loan purchase" do
      it "returns false with purchase price nil" do
        @service.loan.purpose = "purchase"
        @service.subject_property.purchase_price = nil

        expect(@service.purpose_completed?).to eq(false)
      end

      it "returns true with valid purchase price" do
        @service.loan.purpose = "purchase"

        expect(@service.purpose_completed?).to eq(true)
      end
    end

    context "with loan refinance" do
      it "returns false with purchase price nil" do
        @service.loan.purpose = "refinance"
        @service.subject_property.original_purchase_price = nil

        expect(@service.purpose_completed?).to eq(false)
      end

      it "returns false with purchase year nil" do
        @service.loan.purpose = "refinance"
        @service.subject_property.original_purchase_year = nil

        expect(@service.purpose_completed?).to eq(false)
      end

      it "returns true with valid values" do
        @service.loan.purpose = "refinance"
        @service.subject_property.original_purchase_price = 100
        @service.subject_property.original_purchase_year = 10

        expect(@service.purpose_completed?).to eq(true)
      end
    end
  end
end
