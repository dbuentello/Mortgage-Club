require "rails_helper"

describe CompletedLoanServices::TabDeclarations do
  let!(:declaration) { FactoryGirl.create(:declaration_true) }
  let(:service) { CompletedLoanServices::TabDeclarations.new(declaration) }

  it "returns false with declaration nil" do
    service.declaration = nil
    expect(service.call).to be_falsey
  end

  it "returns true with valid values" do
    expect(service.call).to be_truthy
  end

  describe "#declaration_completed" do
    it "returns false with us citizen nil" do
      service.declaration.us_citizen = nil
      expect(service.declaration_completed?).to be_falsey
    end

    it "returns false with permanent resident alien nil" do
      service.declaration.permanent_resident_alien = nil
      service.declaration.us_citizen = false
      expect(service.declaration_completed?).to be_falsey
    end

    it "returns false with ownership interest nil" do
      service.declaration.ownership_interest = nil
      expect(service.declaration_completed?).to be_falsey
    end

    it "returns false with title of property nil" do
      service.declaration.title_of_property = nil
      expect(service.declaration_completed?).to be_falsey
    end

    it "returns false with type of property nil" do
      service.declaration.type_of_property = nil
      expect(service.declaration_completed?).to be_falsey
    end

    it "returns true with valid values" do
      expect(service.declaration_completed?).to be_truthy
    end
  end
end
