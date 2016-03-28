require "rails_helper"

describe BorrowerServices::UpdateEmploymentForBorrower do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:borrower) { FactoryGirl.create(:borrower, user: user) }
  let!(:service) { BorrowerServices::UpdateEmploymentForBorrower.new(borrower) }

  before(:each) { borrower.employments.destroy_all }

  describe "#call" do
    it "returns nil with borrower nil" do
      service.borrower = nil

      expect(service.call).to be_nil
      expect(borrower.employments.count).to eq(0)
    end

    it "returns nil with borrower user nil" do
      service.borrower.user = nil

      expect(service.call).to be_nil
      expect(borrower.employments.count).to eq(0)
    end

    context "with params valid" do
      it "does not create new employment with current job info nil" do
        personal_info = {
          current_job_info: {
            title: nil,
            years: nil,
            company_name: nil
          }
        }
        allow_any_instance_of(FullContactServices::GetPersonalInfo).to receive(:call).and_return(personal_info)

        service.call

        expect(borrower.employments.count).to eq(0)
      end

      context "with company info valid" do
      end

      context "without company info invalid" do
        it "creates new current employment for borrower" do
          personal_info = {
            current_job_info: {
              title: "Developer",
              years: 5,
              company_name: "Microsoft"
            },
            prev_job_info: {
              title: nil,
              years: nil,
              company_name: nil
            }
          }
          company_info = {
            contact_name: nil,
            contact_phone_number: nil,
            city: nil,
            state: nil,
            street_address: nil,
            zip: nil
          }

          allow_any_instance_of(FullContactServices::GetPersonalInfo).to receive(:call).and_return(personal_info)
          allow_any_instance_of(ClearbitServices::Discovery).to receive(:call).and_return(personal_info)

          service.call

          expect(borrower.employments.count).to eq(1)

          expect(borrower.current_employment).not_to be_nil
          expect(borrower.current_employment.job_title).to eq(personal_info[:current_job_info][:title])
          expect(borrower.current_employment.duration).to eq(personal_info[:current_job_info][:years])
          expect(borrower.current_employment.employer_name).to eq(personal_info[:current_job_info][:company_name])

          expect(borrower.current_employment.address).to be_nil
        end

        it "creates new current employment, previous employment for borrower" do
          personal_info = {
            current_job_info: {
              title: "Developer",
              years: 1,
              company_name: "Microsoft"
            },
            prev_job_info: {
              title: "Developer",
              years: 3,
              company_name: "Facebook"
            }
          }
          company_info = {
            contact_name: nil,
            contact_phone_number: nil,
            city: nil,
            state: nil,
            street_address: nil,
            zip: nil
          }
          allow_any_instance_of(FullContactServices::GetPersonalInfo).to receive(:call).and_return(personal_info)
          allow_any_instance_of(ClearbitServices::Discovery).to receive(:call).and_return(personal_info)

          service.call

          expect(borrower.employments.count).to eq(2)

          expect(borrower.current_employment).not_to be_nil
          expect(borrower.current_employment.job_title).to eq(personal_info[:current_job_info][:title])
          expect(borrower.current_employment.duration).to eq(personal_info[:current_job_info][:years])
          expect(borrower.current_employment.employer_name).to eq(personal_info[:current_job_info][:company_name])

          expect(borrower.current_employment.address).to be_nil

          expect(borrower.previous_employment).not_to be_nil
          expect(borrower.previous_employment.job_title).to eq(personal_info[:prev_job_info][:title])
          expect(borrower.previous_employment.duration).to eq(personal_info[:prev_job_info][:years])
          expect(borrower.previous_employment.employer_name).to eq(personal_info[:prev_job_info][:company_name])
        end
      end
    end
  end
end
