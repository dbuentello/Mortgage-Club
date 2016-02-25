require "rails_helper"

describe CompletedLoanServices::TabAssets do
  let!(:loan) { FactoryGirl.create(:loan_with_properties) }
  let!(:asset) { FactoryGirl.create(:asset, borrower: loan.borrower) }
  let!(:address) { FactoryGirl.create(:address)}

  before(:each) do
    loan.primary_property.update(address: nil)

    @loan_params = {
      assets: loan.borrower.assets,
      subject_property: loan.subject_property,
      rental_properties: loan.rental_properties,
      primary_property: loan.primary_property,
      own_investment_property: loan.own_investment_property,
      loan_refinance: loan.refinance?,
      borrower: loan.borrower
    }

    @service = CompletedLoanServices::TabAssets.new(@loan_params)
  end

  it "returns false with borrower nil" do
    @service.borrower = nil
    expect(@service.call).to be_falsey
  end

  it "returns false with borrower current address nil" do
    @service.borrower.borrower_addresses.where(is_current: true).destroy_all
    expect(@service.call).to be_falsey
  end

  it "returns false with subject property nil" do
    @service.subject_property = nil
    expect(@service.call).to be_falsey
  end

  it "returns false with assets not valid" do
    @service.assets[0].institution_name = nil
    expect(@service.call).to be_falsey
  end

  it "returns false with renter properties not valid" do
    @service.own_investment_property = true
    @service.rental_properties.first.property_type = nil
    expect(@service.call).to be_falsey
  end

  it "returns true with valid values" do
    expect(@service.call).to be_truthy
  end

  describe "check assets completed" do
    it "returns false with asset not valid" do
      @service.assets[0].institution_name = nil
      expect(@service.assets_completed?).to be_falsey
    end

    it "returns true with assets valid" do
      expect(@service.assets_completed?).to be_truthy
    end
  end

  describe "check asset completed" do
    it "returns false with institution name nil" do
      asset.institution_name = nil
      expect(@service.asset_completed?(asset)).to be_falsey
    end

    it "returns false with asset type nil" do
      asset.asset_type = nil
      expect(@service.asset_completed?(asset)).to be_falsey
    end

    it "returns false with current balance nil" do
      asset.current_balance = nil
      expect(@service.asset_completed?(asset)).to be_falsey
    end

    it "returns true with valid values" do
      expect(@service.asset_completed?(asset)).to be_truthy
    end
  end

  describe "checks rental properties completed" do
    it "returns true with own investment property nil" do
      @service.own_investment_property = nil
      expect(@service.rental_properties_completed?).to be_truthy
    end

    it "returns true with own investment property false" do
      @service.own_investment_property = false
      expect(@service.rental_properties_completed?).to be_truthy
    end

    it "returns false with rental properties not valid" do
      @service.own_investment_property = true
      @service.rental_properties.first.property_type = nil
      expect(@service.rental_properties_completed?).to be_falsey
    end
  end

  describe "checks subject property completed" do
    before do
      @property = @service.subject_property
    end

    it "returns false with property type nil" do
      @property.property_type = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with address nil" do
      @property.address = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with usage nil" do
      @property.usage = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with market price nil" do
      @property.market_price = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with escrows nil" do
      @service.loan_refinance = true
      @property.mortgage_includes_escrows = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with estimated property tax nil" do
      @property.estimated_property_tax = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns false with estimated hazard insurance nil" do
      @property.estimated_hazard_insurance = nil
      expect(@service.property_completed?(@property)).to be_falsey
    end

    it "returns true with valid values" do
      expect(@service.property_completed?(@property)).to be_truthy
    end
  end

  context "with valid primary property" do
    describe "checks primary property completed" do
      before do
        @property = @service.primary_property
      end

      it "returns false with property type nil" do
        @property.property_type = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with borrower current address nil" do
        @service.borrower.current_address.address = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with usage nil" do
        @property.usage = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with market price nil" do
        @property.market_price = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with escrows nil" do
        @service.loan_refinance = true
        @property.mortgage_includes_escrows = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with estimated property tax nil" do
        @property.estimated_property_tax = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns false with estimated hazard insurance nil" do
        @property.estimated_hazard_insurance = nil
        expect(@service.property_completed?(@property)).to be_falsey
      end

      it "returns true with valid values" do
        expect(@service.property_completed?(@property)).to be_truthy
      end
    end
  end

  describe "checks address completed" do
    it "returns false with address nil" do
      expect(@service.address_completed?(false, nil)).to be_falsey
    end

    context "with is rental false" do
      it "returns false with all field nil" do
        address.street_address = nil
        address.city = nil
        address.state = nil
        address.zip = nil
        address.street_address2 = nil

        expect(@service.address_completed?(false, address)).to be_falsey
      end

      it "returns false with street address nil" do
        address.street_address = nil
        expect(@service.address_completed?(false, address)).to be_falsey
      end

      it "returns false with city nil" do
        address.city = nil
        expect(@service.address_completed?(false, address)).to be_falsey
      end

      it "returns false with state nil" do
        address.state = nil
        expect(@service.address_completed?(false, address)).to be_falsey
      end

      it "returns false with zip nil" do
        address.zip = nil
        expect(@service.address_completed?(false, address)).to be_falsey
      end

      it "returns true with valid values" do
        expect(@service.address_completed?(false, address)).to be_truthy
      end
    end

    context "with is rental true" do
      it "returns false with all field nil" do
        address.street_address = nil
        address.city = nil
        address.state = nil
        address.zip = nil
        address.street_address2 = nil

        expect(@service.address_completed?(true, address)).to be_falsey
      end

      it "returns true with street address nil" do
        address.street_address = nil
        expect(@service.address_completed?(true, address)).to be_truthy
      end

      it "returns true with city nil" do
        address.city = nil
        expect(@service.address_completed?(true, address)).to be_truthy
      end

      it "returns true with state nil" do
        address.state = nil
        expect(@service.address_completed?(true, address)).to be_truthy
      end

      it "returns true with zip nil" do
        address.zip = nil
        expect(@service.address_completed?(true, address)).to be_truthy
      end

      it "returns true with street address 2 nil" do
        address.street_address2 = nil
        expect(@service.address_completed?(true, address)).to be_truthy
      end

      it "returns true with valid values" do
        expect(@service.address_completed?(true, address)).to be_truthy
      end
    end
  end
end
