require "rails_helper"

describe CompletedLoanServices::TabDeclarations do
  let!(:declaration) { FactoryGirl.create(:declaration_true) }

  before(:each) do
    @service = CompletedLoanServices::TabDeclarations.new(declaration)
  end

  it "returns false with declaration nil" do
    @service.declaration = nil
    expect(@service.call).to eq(false)
  end

  it "returns false with outstanding judgment nil" do
    @service.declaration.outstanding_judgment = nil
    expect(@service.call).to eq(false)
  end

  it "returns true with valid values" do
    expect(@service.call).to eq(true)
  end

  describe "#declaration_completed" do
    it "returns false with outstanding judgment nil" do
      @service.declaration.outstanding_judgment = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with bankrupt nil" do
      @service.declaration.bankrupt = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with property foreclosed nil" do
      @service.declaration.property_foreclosed = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with party to lawsuit nil" do
      @service.declaration.party_to_lawsuit = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with loan foreclosure nil" do
      @service.declaration.loan_foreclosure = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with child support nil" do
      @service.declaration.child_support = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with down payment borrowed nil" do
      @service.declaration.down_payment_borrowed = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with co maker or endorser nil" do
      @service.declaration.co_maker_or_endorser = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with present delinquent loan nil" do
      @service.declaration.present_delinquent_loan = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with us citizen nil" do
      @service.declaration.us_citizen = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with permanent resident alien nil" do
      @service.declaration.permanent_resident_alien = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with ownership interest nil" do
      @service.declaration.ownership_interest = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with title of property nil" do
      @service.declaration.title_of_property = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns false with type of property nil" do
      @service.declaration.type_of_property = nil
      expect(@service.declaration_completed?).to eq(false)
    end

    it "returns true with valid values" do
      expect(@service.declaration_completed?).to eq(true)
    end
  end
end
