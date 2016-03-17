require "rails_helper"

describe OcrServices::UpdateEmployment do
  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:data) do
    {
      employer_name: "Apple Inc",
      period: "monthly",
      current_salary: 5000,
      ytd_salary: 40000,
      employer_full_address: "1 Infinite Loop Cupertino CA 95014"
    }
  end

  context "with existent borrower" do
    context "with existent employment" do
      before(:each) do
        borrower.employments.destroy_all
        @employment = FactoryGirl.create(:employment, borrower: borrower, is_current: true)
      end

      it "calls #update_employment" do
        expect_any_instance_of(OcrServices::UpdateEmployment).to receive(:update_employment)
        OcrServices::UpdateEmployment.new(data, borrower.id).call
      end

      describe "#update_employment" do
        it "updates right value for employment" do
          OcrServices::UpdateEmployment.new(data, borrower.id).call
          @employment.reload

          expect(@employment.employer_name).to eq("Apple Inc")
          expect(@employment.pay_frequency).to eq("monthly")
          expect(@employment.current_salary).to eq(5000)
          expect(@employment.ytd_salary).to eq(40000)
        end

        context "with existent address" do
          it "calls #update_employer_address" do
            expect_any_instance_of(OcrServices::UpdateEmployment).to receive(:update_employer_address)
            OcrServices::UpdateEmployment.new(data, borrower.id).call
          end

          describe "#update_employer_address" do
            it "updates full_text field of address" do
              OcrServices::UpdateEmployment.new(data, borrower.id).call
              @employment.address.reload

              expect(@employment.address.full_text).to eq("1 Infinite Loop Cupertino CA 95014")
            end
          end
        end

        context "with non-existent address" do
          it "calls #create_employer_address" do
            @employment.address = nil
            expect_any_instance_of(OcrServices::UpdateEmployment).to receive(:create_employer_address)
            OcrServices::UpdateEmployment.new(data, borrower.id).call
          end
        end
      end
    end

    context "with non-existent employment" do
      before(:each) do
        borrower.employments.destroy_all
      end

      describe "#create_new_employment" do
        it "creates a new employment" do
          expect { OcrServices::UpdateEmployment.new(data, borrower.id).call }.to change { Employment.count }.by(1)
        end
      end

      describe "#create_employer_address" do
        it "creates a new address" do
          expect { OcrServices::UpdateEmployment.new(data, borrower.id).call }.to change { Address.count }.by(1)
        end
      end
    end
  end

  context "with non-existent borrower" do
    it "returns nil" do
      expect(OcrServices::UpdateEmployment.new(nil, nil).call).to be_nil
    end
  end
end
