require "rails_helper"

describe ZillowService::GetMonthlyPayment do
  context "with valid params" do
    it "gets monthly payment from Zillow successfully" do
      VCR.use_cassette("get monthly payment from Zillow") do
        params ={
          "property_value" => "500000",
          "zip_code" => "94103"
        }
        monthly_payment = ZillowService::GetMonthlyPayment.new(params).call

        expect(monthly_payment[:property_tax]).not_to eq(0.0)
        expect(monthly_payment[:monthlyInsurance]).not_to eq(0.0)
      end
    end
  end

  context "with invalid params" do
    context "when property value is nil" do
      it "returns nil" do
        params ={
          "property_value" => nil,
          "zip_code" => "94103"
        }
        monthly_payment = ZillowService::GetMonthlyPayment.new(params).call

        expect(monthly_payment).to be_nil
      end
    end

    context "when zip code is nil" do
      it "returns nil" do
        params ={
          "property_value" => "500000",
          "zip_code" => nil
        }
        monthly_payment = ZillowService::GetMonthlyPayment.new(params).call

        expect(monthly_payment).to be_nil
      end
    end
  end
end
