require "rails_helper"

describe BorrowerForm do
  let(:loan) { FactoryGirl.create(:loan_with_properties) }
  let(:borrower) { loan.borrower }
  let(:borrower_address) { FactoryGirl.create(:borrower_address, borrower: borrower, is_current: true) }

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

    @params_own_address = {
      current_address: {street_address: "12740 El Camino Real", street_address2: "",
      zip: "93422", state: "CA", employment_id: "", city: "Atascadero",
      full_text: "12740 El Camino Real, Atascadero, CA, United States"},
      previous_address: {},
      current_borrower_address:
        {is_rental: "false",
        years_at_address: "10", monthly_rent: "12", is_current: "true"},
      previous_borrower_address:
        {is_rental: "true", is_current: "false"},
      borrower:
        {first_name: "John", middle_name: "", last_name: "Doe", suffix: "",
          dob: "1969-12-31T17:00:00.000Z", ssn: "233-43-4444", phone: "090009099",
          years_in_school: "12", marital_status: "", dependent_ages: [12], dependent_count: 10, self_employed: "false"},
      loan_id: loan.id
    }

    @params_with_too_big_monthly_rent = {
      current_address: {street_address: "12740 El Camino Real", street_address2: "",
      zip: "93422", state: "CA", employment_id: "", city: "Atascadero",
      full_text: "12740 El Camino Real, Atascadero, CA, United States"},
      previous_address: {},
      current_borrower_address:
        {is_rental: "true",
        years_at_address: "10", monthly_rent: "100123000123", is_current: "true"},
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

    @form_with_too_big_montly_rent = described_class.new(
      form_params: @params_with_too_big_monthly_rent,
      borrower: borrower,
      loan: loan
    )

    @form_with_borrower_own_address = described_class.new(
      form_params: @params_own_address,
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
      it "raises error when monthly_rent exceeds maximum allowed value" do
        expect { raise @form_with_too_big_montly_rent.save }.to raise_error(ActiveRecord::StatementInvalid)
      end
      # implement later, we haven't set up validations for these models
    end

    context "with borrower current address rent" do
      it "destroys primary property" do
        @form.is_primary_borrower = true
        @form.save

        expect(loan.primary_property).to be_nil
      end
    end

    context "with borrower current address own" do
      context "with loan has no primary property" do
        it "creates new primary property" do
          @form_with_borrower_own_address.loan.properties.find_by(is_primary: true).destroy
          @form_with_borrower_own_address.is_primary_borrower = true
          @form_with_borrower_own_address.save

          expect(loan.primary_property).not_to be_nil
          expect(loan.primary_property.is_primary).to be_truthy
          expect(loan.primary_property.usage).to eq("primary_residence")
        end
      end
    end
  end

  describe "#update_primary_property" do
    context "when borrower rents house" do
      it "destroys primary property" do
        @form.borrower.current_address.update(is_rental: true)
        @form.update_primary_property

        expect(@form.loan.primary_property).to be_nil
      end
    end
    context "when borrower owns house" do
      context "with primary property exist" do
        it "returns nil" do
          @form.loan.borrower.current_address.update(is_rental: false)

          expect(@form.update_primary_property).to be_nil
        end
      end
      context "with primary property not exist" do
        it "returns new primary property" do
          @form.loan.borrower.current_address.update(is_rental: false)
          @form.loan.primary_property.destroy
          @form.update_primary_property
          primary_property = @form.loan.primary_property

          expect(primary_property).not_to be_nil
          expect(primary_property.address.street_address).to eq(borrower.current_address.address.street_address)
          expect(primary_property.address.zip).to eq(borrower.current_address.address.zip)
          expect(primary_property.address.state).to eq(borrower.current_address.address.state)
          expect(primary_property.address.city).to eq(borrower.current_address.address.city)
        end
      end
    end
  end
end
