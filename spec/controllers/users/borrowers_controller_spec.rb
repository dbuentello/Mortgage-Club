require "rails_helper"

describe Users::BorrowersController do
  include_context "signed in as borrower user of loan"
  describe "GET #update" do
    let!(:loan) { FactoryGirl.create(:loan) }
    let!(:borrower) { FactoryGirl.create(:borrower) }

    before do
      @borrower_params =
      {
        current_address:
        {
          street_address: "12740 El Camino Real",
          street_address2: "",
          zip: "93422",
          state: "CA",
          property_id: "",
          employment_id: "",
          city: "Atascadero",
          full_text: "12740 El Camino Real, Atascadero, CA, United States"
        },
        previous_address: FactoryGirl.attributes_for(:address),
        current_borrower_address:
        {
          is_rental: "true",
          years_at_address: "18",
          monthly_rent: "12",
          is_current: "true"
        },
        previous_borrower_address:
        {
          is_rental: "true",
          is_current: "false"
        },
        borrower:
        {
          email: "borrower@gmail.com",
          first_name: "John",
          middle_name: "",
          last_name: "Doe",
          suffix: "",
          dob: "1969-12-31T17:00:00.000Z",
          ssn: "233-43-4444",
          phone: "(437) 678-4933",
          years_in_school: "12",
          marital_status: "",
          dependent_count: "0",
          self_employed: "false"
        }
      }

      @secondary_borrower =
      {
        current_address:
        {
          street_address: "23 Park Avenue",
          street_address2: "",
          city: "New York",
          state: "NY",
          zip: "10016",
          full_text: "23 Park Avenue, New York, NY, United States"
        },
        previous_address: FactoryGirl.attributes_for(:address),
        current_borrower_address:
        {
          is_rental: "true",
          years_at_address: "4",
          monthly_rent: "345",
          is_current: "true"
        },
        previous_borrower_address:
        {
          is_rental: "true",
          is_current: "false"
        },
        borrower:
        {
          email: "hfdi@example.com",
          first_name: "almg",
          middle_name: "",
          last_name: "nguo",
          suffix: "",
          dob: "1990-12-23T17:00:00.000Z",
          ssn: "334-44-5555",
          phone: "(342) 289-9555",
          years_in_school: "12",
          marital_status: "",
          dependent_count: "0",
          self_employed: "false"
        }
      }
    end

    context "when applying as an individual" do
      context "with valid params" do
        it "calls BorrowerForm and returns true" do
          expect_any_instance_of(BorrowerForm).to receive(:save).and_return(true)
          put :update, id: borrower.id, borrower: @borrower_params, loan_id: loan.id
        end

        it "returns status 200" do
          put :update, id: borrower.id, borrower: @borrower_params, loan_id: loan.id
          expect(response.status).to eq 200
        end

        it "calls RemoveSecondaryBorrower service" do
          expect(BorrowerServices::RemoveSecondaryBorrower).to receive(:call)
          put :update, id: borrower.id, borrower: @borrower_params, loan_id: loan.id
        end
      end

      context "with invalid params" do
        before(:each) do
          allow_any_instance_of(BorrowerForm).to receive(:save).and_return(false)
          put :update, id: borrower.id, borrower: @borrower_params, loan_id: loan.id
        end

        it "calls BorrowerForm.save and returns false" do
          expect_any_instance_of(BorrowerForm).to receive(:save).and_return(false)
          put :update, id: borrower.id, borrower: @borrower_params, loan_id: loan.id
        end

        it "retuns status 500" do
          expect(response.status).to eq(500)
        end
      end
    end

    context "when applying as secondary borrower" do
      context "with valid params both borrower" do
        it "calls AssignSecondaryBorrowerToLoan service" do
          expect_any_instance_of(BorrowerServices::AssignSecondaryBorrowerToLoan).to receive(:call)
          put :update, id: borrower.id, borrower: @borrower_params, has_secondary_borrower: "true", loan_id: loan.id, secondary_borrower: @secondary_borrower
        end

        it "calls BorrowerForm save" do
          expect_any_instance_of(BorrowerForm).to receive(:save)
          put :update, id: borrower.id, borrower: @borrower_params, has_secondary_borrower: "true", loan_id: loan.id, secondary_borrower: @secondary_borrower
        end
      end

      context "with invalid params" do
        before(:each) do
          allow_any_instance_of(BorrowerForm).to receive(:save).and_return(false)
          put :update, id: borrower.id, borrower: @borrower_params, has_secondary_borrower: "true", loan_id: loan.id, secondary_borrower: @secondary_borrower
        end

        it "calls BorrowerForm.save and returns false" do
          expect_any_instance_of(BorrowerForm).to receive(:save).and_return(false)
          put :update, id: borrower.id, borrower: @borrower_params, has_secondary_borrower: "true", loan_id: loan.id, secondary_borrower: @secondary_borrower
        end
      end
    end
  end
end
