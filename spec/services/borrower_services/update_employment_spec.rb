require "rails_helper"

describe BorrowerServices::UpdateEmployment do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:borrower) { FactoryGirl.create(:borrower, user: user) }
  let!(:service) { BorrowerServices::UpdateEmployment.new(borrower) }

  before(:each) { borrower.employments.destroy_all }

  describe "#call" do
    context "when borrower is nil" do
      it "returns nil" do
        service.borrower = nil

        expect(service.call).to be_nil
        expect(borrower.employments.count).to eq(0)
      end
    end

    context "when borrower user nil" do
      it "returns nil" do
        service.borrower.user = nil

        expect(service.call).to be_nil
        expect(borrower.employments.count).to eq(0)
      end
    end

    context "with valid params" do
      context "when fields of current job info are nil" do
        it "does not create new employment" do
          personal_info = {
            current_job_info: {
              title: nil,
              years: nil,
              company_name: nil
            },
            prev_job_info: {
              title: nil,
              years: nil,
              company_name: nil
            }
          }
          allow_any_instance_of(FullContactServices::GetPersonalInfo).to receive(:call).and_return(personal_info)

          service.call

          expect(borrower.employments.count).to eq(0)
        end
      end

      context "with invalid company info" do
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
          allow_any_instance_of(ClearbitServices::Discovery).to receive(:call).and_return(company_info)

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
          allow_any_instance_of(ClearbitServices::Discovery).to receive(:call).and_return(company_info)

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

      context "with valid company info" do
        it "saves address for current employment" do
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
            contact_name: "HR Hunter",
            contact_phone_number: "(123) 456-7890",
            city: "New York",
            state: "LA",
            street_address: "123 Silver Street",
            zip: "95143"
          }

          allow_any_instance_of(FullContactServices::GetPersonalInfo).to receive(:call).and_return(personal_info)
          allow_any_instance_of(ClearbitServices::Discovery).to receive(:call).and_return(company_info)

          service.call

          expect(borrower.employments.count).to eq(1)

          expect(borrower.current_employment).not_to be_nil
          expect(borrower.current_employment.job_title).to eq(personal_info[:current_job_info][:title])
          expect(borrower.current_employment.duration).to eq(personal_info[:current_job_info][:years])
          expect(borrower.current_employment.employer_name).to eq(personal_info[:current_job_info][:company_name])
          expect(borrower.current_employment.employer_contact_name).to eq(company_info[:contact_name])
          expect(borrower.current_employment.employer_contact_number).to eq(company_info[:contact_phone_number])

          expect(borrower.current_employment.address).not_to be_nil
          expect(borrower.current_employment.address.city).to eq(company_info[:city])
          expect(borrower.current_employment.address.state).to eq(company_info[:state])
          expect(borrower.current_employment.address.street_address).to eq(company_info[:street_address])
          expect(borrower.current_employment.address.zip).to eq(company_info[:zip])
        end
      end
    end
  end
end
