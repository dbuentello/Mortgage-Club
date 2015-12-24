require "rails_helper"

describe BorrowerForm do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:borrower_address) { FactoryGirl.create(:borrower_address, borrower: borrower) }

  before(:each) do
    @params = {
      current_address: {street_address: "12740 El Camino Real", street_address2: "",
      zip: "93422", state: "CA", employment_id: "", city: "Atascadero",
      full_text: "12740 El Camino Real, Atascadero, CA, United States"},
      previous_address: {},
      current_borrower_address:
        {is_rental: "true",
        years_at_address: "10", monthly_rent: "12", is_current: "true"},
      previous_borrower_address:
        {is_rental: "true", is_current: "false"},
      borrower:
        {first_name: "John", middle_name: "", last_name: "Doe", suffix: "",
          dob: "1969-12-31T17:00:00.000Z", ssn: "233-43-4444", phone: "090009099",
          years_in_school: "12", marital_status: "", dependent_ages: [12], dependent_count: 10, self_employed: "false"},
      loan_id: loan.id
    }

    @form = described_class.new(
      form_params: @params,
      borrower: borrower,
      loan: loan
    )
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

    context "with valid params" do
      before(:each) { @form.save }

      it "returns true" do
        expect(@form.save).to be_truthy
      end
    end

    context "with primary borrower" do
      it "calls #update_primary_property" do
        @form.is_primary_borrower = true
        expect(@form).to receive(:update_primary_property)
        @form.save
      end
    end

    context "when borrower must have previous address" do
      it "calls #update_old_address" do
        allow_any_instance_of(Borrower).to receive(:must_have_previous_address?).and_return(true)
        expect(@form).to receive(:update_old_address)
        @form.save
      end
    end

    context "with invalid params" do
      # implement later, we haven't set up validations for these models
    end
  end
end
