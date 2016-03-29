require "rails_helper"

describe FullContactServices::GetPersonalInfo do
  let!(:service) { described_class.new("cuongvu0103@gmail.com") }
  let!(:personal_info_default) do
    {
      current_job_info:
      {
        title: nil,
        years: nil,
        company_name: nil
      },
      prev_job_info:
      {
        title: nil,
        years: nil,
        company_name: nil
      }
    }
  end

  describe "#call" do
    context "with valid email" do
      context "when email exists in FullContact" do
        it "returns status 200" do
          VCR.use_cassette("get status 200 from FullContact") do
            service.email = "cuongvu0103@gmail.com"

            service.call

            expect(service.response.status).to eq(200)
            expect(service.personal_info).not_to eq(personal_info_default)
          end
        end
      end

      context "when email does not exist in FullContact" do
        it "returns status 404" do
          VCR.use_cassette("get status 404 from FullContact") do
            service.email = "abcdef@ghi.com"

            service.call

            expect(service.response.status).to eq(404)
            expect(service.personal_info).to eq(personal_info_default)
          end
        end
      end
    end

    context "with invalid email" do
      it "returns status 422" do
        VCR.use_cassette("get status 422 from FullContact") do
          service.email = "cuongvu0103"

          service.call

          expect(service.response.status).to eq(422)
          expect(service.personal_info).to eq(personal_info_default)
        end
      end
    end
  end

  describe "#read_personal_info" do
    context "when response data contains organizations" do
      it "calls #read_positions_info" do
        response_data = {
          "organizations" => [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => true
            }
          ]
        }

        expect_any_instance_of(described_class).to receive(:read_positions_info)

        service.read_personal_info(response_data)
      end
    end

    context "when response data doesn't contain organizations" do
      context "with organizations not present" do
        it "does not call #read_positions_info" do
          response_data = {"organizations" => []}

          expect_any_instance_of(described_class).not_to receive(:read_positions_info)

          service.read_personal_info(response_data)
        end
      end

      context "with organizations nil" do
        it "does not call #read_positions_info" do
          response_data = {}

          expect_any_instance_of(described_class).not_to receive(:read_positions_info)

          service.read_personal_info(response_data)
        end
      end
    end
  end

  describe "#read_positions_info" do
    context "with 1 position" do
      context "with data valid" do
        it "assigns current job info with current true" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => true
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to eq("developer")
          expect(service.personal_info[:current_job_info][:company_name]).to eq("Microsoft")
          expect(service.personal_info[:current_job_info][:years]).to be >= 1
        end

        it "does not assign current job info with current false" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => false
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info).to eq(personal_info_default)
        end
      end

      context "with data invalid" do
        it "returns current job title nil with title nil" do
          positions = [
            {
              "title" => nil,
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => true
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to be_nil
          expect(service.personal_info[:current_job_info][:company_name]).to eq("Microsoft")
          expect(service.personal_info[:current_job_info][:years]).to be >= 1
        end

        it "returns current job employer name nil with name nil" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => nil,
              "current" => true
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to eq("developer")
          expect(service.personal_info[:current_job_info][:company_name]).to be_nil
          expect(service.personal_info[:current_job_info][:years]).to be >= 1
        end

        it "returns current job years 0 with startDate nil" do
          positions = [
            {
              "title" => "developer",
              "startDate" => nil,
              "name" => "Microsoft",
              "current" => true
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to eq("developer")
          expect(service.personal_info[:current_job_info][:company_name]).to eq("Microsoft")
          expect(service.personal_info[:current_job_info][:years]).to eq(0)
        end
      end
    end
    context "with 2 positions" do
      context "when 2 previous positions" do
        it "does not assign current position" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => false
            },
            {
              "title" => "developer",
              "startDate" => "2014-12",
              "endDate" => "2016-01",
              "name" => "Facebook",
              "current" => false
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info).to eq(personal_info_default)
        end
      end

      context "with 1 current position, 1 previous position" do
        it "assign current job info with current position duration greater 1" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2015-01",
              "name" => "Microsoft",
              "current" => true
            },
            {
              "title" => "developer",
              "startDate" => "2013-12",
              "endDate" => "2015-01",
              "name" => "Facebook",
              "current" => false
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to eq("developer")
          expect(service.personal_info[:current_job_info][:company_name]).to eq("Microsoft")
          expect(service.personal_info[:current_job_info][:years]).to be > 1
        end

        it "assign current job info, previous job info with current position duration less than 2" do
          positions = [
            {
              "title" => "developer",
              "startDate" => "2016-01",
              "name" => "Microsoft",
              "current" => true
            },
            {
              "title" => "developer",
              "startDate" => "2013-12",
              "endDate" => "2016-01",
              "name" => "Facebook",
              "current" => false
            }
          ]

          service.read_positions_info(positions)

          expect(service.personal_info[:current_job_info][:title]).to eq("developer")
          expect(service.personal_info[:current_job_info][:company_name]).to eq("Microsoft")
          expect(service.personal_info[:current_job_info][:years]).to eq(1)

          expect(service.personal_info[:prev_job_info][:title]).to eq("developer")
          expect(service.personal_info[:prev_job_info][:company_name]).to eq("Facebook")
          expect(service.personal_info[:prev_job_info][:years]).to eq(3)
        end
      end
    end
  end

  describe "#get_work_years" do
    context "with start date invalid" do
      context "with end date invalid" do
        it "returns 0" do
          expect(service.get_work_years(nil, nil)).to eq(0)
        end
      end

      context "with end date valid" do
        it "returns 0" do
          expect(service.get_work_years(nil, "2016-12")).to eq(0)
        end
      end
    end

    context "with start date valid"
    context "with end date invalid" do
      it "returns 0" do
        expect(service.get_work_years("2016-12", nil)).to eq(0)
      end
    end

    context "with end date valid" do
      context "when start year equals end year" do
        it "returns 1" do
          expect(service.get_work_years("2016-03", "2016-09")).to eq(1)
        end
      end

      context "when end year subtracts start year 1" do
        it "returns 1 when start month greater than end month" do
          expect(service.get_work_years("2016-09", "2017-03")).to eq(1)
        end

        it "returns 2 when start month less than end month" do
          expect(service.get_work_years("2016-03", "2017-09")).to eq(2)
        end
      end
    end
  end
end
