require "rails_helper"

describe BorrowerForm do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:borrower_address) { FactoryGirl.create(:borrower_address, borrower: borrower) }
  let(:address) { FactoryGirl.create(:address, borrower_address: borrower_address) }

  before(:each) do
    @params = {
      current_address: {},
      previous_address: {},
      previous_borrower_address: {}
      current_borrower_address: {
        years_at_address: 10,
        is_rental: true
      },
      borrower: {
        phone: "090009099",
        dependent_ages: [12],
        dependent_count: 10
      },
      loan_id: loan.id,
    }
    @form = BorrowerForm.new(
      form_params: @params,
      borrower: borrower,
      current_address: address,
      current_borrower_address: borrower_address,
      loan: loan
    )
  end

  describe "#assign_value_to_attributes" do
    before(:each) { @form.assign_value_to_attributes }

    it "assigns value to address's attributes" do
      expect(@form.current_address.street_address).to eq(address.street_address)
      expect(@form.current_address.city).to eq(address.city)
      expect(@form.current_address.zip).to eq(address.zip)
    end

    it "assigns value to borrower_address's attributes" do
      expect(@form.current_borrower_address.years_at_address).to eq(10)
      expect(@form.current_borrower_address.is_rental).to eq(true)
      expect(@form.current_borrower_address.is_current).to eq(true)
    end

    it "assigns value to borrower's attributes" do
      expect(@form.borrower.phone).to eq("090009099")
      expect(@form.borrower.dependent_ages).to eq([12])
      expect(@form.borrower.dependent_count).to eq(10)
    end
  end

  describe "#setup_associations" do
    it "assigns associations" do
      @form.setup_associations

      expect(@form.current_borrower_address.address).to eq(@form.current_address)
      expect(@form.borrower.borrower_addresses).to include(@form.current_borrower_address)
    end
  end

  describe "#save" do
    it "calls assign_value_to_attributes method" do
      expect(@form).to receive(:assign_value_to_attributes)
      @form.save
    end

    it "calls setup_associations" do
      expect(@form).to receive(:setup_associations)
      @form.save
    end

    context "valid params" do
      before(:each) { @form.save }

      it "returns true" do
        expect(@form.save).to be_truthy
      end

      it "creates a new address successfully" do
        expect(@form.current_address.persisted?).to be_truthy
        expect(@form.current_address.street_address).to eq(address.street_address)
        expect(@form.current_address.city).to eq(address.city)
        expect(@form.current_address.zip).to eq(address.zip)
      end

      it "creates a new borrower address successfully" do
        expect(@form.current_borrower_address.persisted?).to be_truthy
        expect(@form.current_borrower_address.years_at_address).to eq(10)
        expect(@form.current_borrower_address.is_rental).to eq(true)
        expect(@form.current_borrower_address.is_current).to eq(true)
      end

      it "updates a borrower successfully" do
        expect(@form.borrower.persisted?).to be_truthy
        expect(@form.borrower.phone).to eq("090009099")
        expect(@form.borrower.dependent_ages).to eq([12])
        expect(@form.borrower.dependent_count).to eq(10)
      end
    end

    context "invalid params" do
      # implement later, we haven't set up validations for these models
    end
  end
end
