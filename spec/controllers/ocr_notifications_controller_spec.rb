require 'rails_helper'

describe OcrNotificationsController do
  describe "#receive" do
    after(:each) { post :receive }
    context "when setting's OCR is true" do
      let!(:setting) { FactoryGirl.create(:setting, ocr: true) }

      it "calls OcrServices::ProcessPaystub" do
        expect(OcrServices::ProcessPaystub).to receive(:call)
      end
    end

    context "when setting's OCR is false" do
      it "does not call OcrServices::ProcessPaystub" do
        expect(OcrServices::ProcessPaystub).not_to receive(:call)
      end
    end
  end
end
