require "rails_helper"

describe CompletedLoanServices::TabDeclarations do
  let!(:borrower) { FactoryGirl.create(:borrower_completed) }
  let!(:co_borrower) { FactoryGirl.create(:borrower_completed) }
  let(:service) { CompletedLoanServices::TabDeclarations.new(borrower, co_borrower) }

  it "returns false with borrower declaration nil" do
    service.borrower.declaration = nil
    service.secondary_borrower = nil
    expect(service.call).to be_falsey
  end

  it "returns false with secondary borrower declaration nil" do
    service.secondary_borrower.declaration = nil
    expect(service.call).to be_falsey
  end

  it "returns true with valid borrower" do
    service.secondary_borrower = nil
    expect(service.call).to be_truthy
  end

  it "returns true with valid borrower and co-borrower" do
    expect(service.call).to be_truthy
  end

  describe "#declaration_completed" do
    before do
      service.secondary_borrower = nil
    end

    it "returns false with citizenship status nil" do
      service.borrower.declaration.citizen_status = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with is hispanic or latino nil" do
      service.borrower.declaration.is_hispanic_or_latino = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with gender type nil" do
      service.borrower.declaration.gender_type = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with race type nil" do
      service.borrower.declaration.race_type = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with ownership interest nil" do
      service.borrower.declaration.ownership_interest = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with title of property nil" do
      service.borrower.declaration.ownership_interest = true
      service.borrower.declaration.title_of_property = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns false with type of property nil" do
      service.borrower.declaration.ownership_interest = true
      service.borrower.declaration.type_of_property = nil
      expect(service.declaration_completed?(service.borrower.declaration)).to be_falsey
    end

    it "returns true with valid values" do
      expect(service.declaration_completed?(service.borrower.declaration)).to be_truthy
    end
  end
end
