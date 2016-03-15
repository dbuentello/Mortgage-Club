require "rails_helper"

describe OcrServices::ProcessPaystub do

  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:ocr_with_first_document) { FactoryGirl.create(:ocr_with_first_document) }

  it "calls ParsePaystubFile service" do
    expect(OcrServices::ParsePaystubFile).to receive(:call).and_return({})
    OcrServices::ProcessPaystub.call(nil)
  end

  # it "calls UpdatePaystubOcr service" do
  #   allow(OcrServices::ParseXmlFile).to receive(:call).and_return({
  #     borrower_id: borrower.id
  #   })
  #   expect_any_instance_of(OcrServices::UpdatePaystubOcr).to receive(:call).and_return(ocr_with_first_document)
  #   OcrServices::ProcessPaystub.call(nil)
  # end

  context "saved_two_paystub_result?" do
    let(:ocr) { FactoryGirl.create(:ocr_with_full_data) }

    before(:each) do
      allow(OcrServices::ParsePaystubFile).to receive(:call).and_return(borrower_id: borrower.id)
      allow_any_instance_of(OcrServices::UpdatePaystubOcr).to receive(:call).and_return(ocr)
    end

    it "calls StandardizePaystubData service" do
      expect_any_instance_of(OcrServices::StandardizePaystubData).to receive(:call).and_return(nil)
      OcrServices::ProcessPaystub.call(nil)
    end

    it "calls UpdateEmployment service" do
      expect_any_instance_of(OcrServices::UpdateEmployment).to receive(:call)
      OcrServices::ProcessPaystub.call(nil)
    end
  end
end
