require "rails_helper"

describe PaystubOcrServices::ProcessPaystub do
  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:ocr_with_first_document) { FactoryGirl.create(:ocr_with_first_document) }

  it "calls ParseXmlFile service" do
    expect(PaystubOcrServices::ParseXmlFile).to receive(:call).and_return({})
    PaystubOcrServices::ProcessPaystub.call(nil)
  end

  # it "calls UpdatePaystubOcr service" do
  #   allow(PaystubOcrServices::ParseXmlFile).to receive(:call).and_return({
  #     borrower_id: borrower.id
  #   })
  #   expect_any_instance_of(PaystubOcrServices::UpdatePaystubOcr).to receive(:call).and_return(ocr_with_first_document)
  #   PaystubOcrServices::ProcessPaystub.call(nil)
  # end

  context "saved_two_paystub_result?" do
    let(:ocr) { FactoryGirl.create(:ocr_with_full_data) }

    before(:each) do
      allow(PaystubOcrServices::ParseXmlFile).to receive(:call).and_return({
        borrower_id: borrower.id
      })
      allow_any_instance_of(PaystubOcrServices::UpdatePaystubOcr).to receive(:call).and_return(ocr)
    end

    it "calls StandardizePaystubData service" do
      expect_any_instance_of(PaystubOcrServices::StandardizePaystubData).to receive(:call).and_return(nil)
      PaystubOcrServices::ProcessPaystub.call(nil)
    end

    it "calls UpdateEmployment service" do
      expect_any_instance_of(PaystubOcrServices::UpdateEmployment).to receive(:call)
      PaystubOcrServices::ProcessPaystub.call(nil)
    end
  end
end