require "rails_helper"

describe LoanTekServices::GetQuotes do
  let(:loan) { FactoryGirl.create(:loan_with_properties) }
  let(:service) { described_class.new(loan) }

  describe "#get_quotes" do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:credit_score).and_return(750)
      allow_any_instance_of(described_class).to receive(:zipcode).and_return(95127)
      allow_any_instance_of(described_class).to receive(:loan_amount).and_return(360000)
    end

    it "gets quotes with status 200" do
      VCR.use_cassette("get quotes from LoanTek") do
        service.get_quotes
        expect(service.response.status).to eq(200)
      end
    end

    it "calls LoanTekServices::ReadQuotes service" do
      VCR.use_cassette("get quotes from LoanTek") do
        expect(LoanTekServices::ReadQuotes).to receive(:call)
        service.get_quotes
      end
    end
  end
end
