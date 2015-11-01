require "rails_helper"

describe OcrServices::UpdatePaystubOcr do
  let(:borrower) { FactoryGirl.create(:borrower) }
  let(:data) do
    {
      employer_name: "Apple Inc",
      address_first_line: "1 Infinite Loop Cupertino",
      address_second_line: "CA 95014",
      period_beginning: Time.zone.now,
      period_ending: Time.zone.now + 30.days,
      current_salary: 5000,
      ytd_salary: 40000,
      current_earnings: 0
    }
  end

  context "existent OCR's result" do
    let!(:ocr_result) { FactoryGirl.create(:ocr_with_first_document, borrower: borrower) }

    context "first paystub" do
      before(:each) { data[:order_of_paystub] = 1 }

      it "calls #update_first_paystub_to_ocr" do
        expect_any_instance_of(OcrServices::UpdatePaystubOcr).to receive(:update_first_paystub_to_ocr)
        OcrServices::UpdatePaystubOcr.new(data, borrower.id).call
      end

      it "updates data for field having suffix _1" do
        OcrServices::UpdatePaystubOcr.new(data, borrower.id).call
        ocr_result.reload

        expect(ocr_result.employer_name_1).to eq("Apple Inc")
        expect(ocr_result.address_first_line_1).to eq("1 Infinite Loop Cupertino")
        expect(ocr_result.address_second_line_1).to eq("CA 95014")
        expect(ocr_result.period_beginning_1.to_date).to eq(Time.zone.now.to_date)
        expect(ocr_result.period_ending_1.to_date).to eq((Time.zone.now + 30.days).to_date)
        expect(ocr_result.current_salary_1).to eq(5000)
        expect(ocr_result.ytd_salary_1).to eq(40000)
        expect(ocr_result.current_earnings_1).to eq(0)
      end
    end

    context "second paystub" do
      before(:each) { data[:order_of_paystub] = 2 }

      it "calls #update_second_paystub_to_ocr" do
        expect_any_instance_of(OcrServices::UpdatePaystubOcr).to receive(:update_second_paystub_to_ocr)
        OcrServices::UpdatePaystubOcr.new(data, borrower.id).call
      end

      it "updates data for field having suffix _2" do
        OcrServices::UpdatePaystubOcr.new(data, borrower.id).call
        ocr_result.reload

        expect(ocr_result.employer_name_2).to eq("Apple Inc")
        expect(ocr_result.address_first_line_2).to eq("1 Infinite Loop Cupertino")
        expect(ocr_result.address_second_line_2).to eq("CA 95014")
        expect(ocr_result.period_beginning_2.to_date).to eq(Time.zone.now.to_date)
        expect(ocr_result.period_ending_2.to_date).to eq((Time.zone.now + 30.days).to_date)
        expect(ocr_result.current_salary_2).to eq(5000)
        expect(ocr_result.ytd_salary_2).to eq(40000)
        expect(ocr_result.current_earnings_2).to eq(0)
      end
    end
  end

  context "non-existent OCR's result" do
    it "creates a new OCR's record" do
      expect { OcrServices::UpdatePaystubOcr.new(data, borrower.id).call }.to change{Ocr.count}.by(1)
    end

    it "creates a new OCR's record with right value" do
      ocr_result = OcrServices::UpdatePaystubOcr.new(data, borrower.id).call
      expect(ocr_result.employer_name_1).to eq("Apple Inc")
      expect(ocr_result.address_first_line_1).to eq("1 Infinite Loop Cupertino")
      expect(ocr_result.address_second_line_1).to eq("CA 95014")
      expect(ocr_result.period_beginning_1.to_date).to eq(Time.zone.now.to_date)
      expect(ocr_result.period_ending_1.to_date).to eq((Time.zone.now + 30.days).to_date)
      expect(ocr_result.current_salary_1).to eq(5000)
      expect(ocr_result.ytd_salary_1).to eq(40000)
      expect(ocr_result.current_earnings_1).to eq(0)
    end
  end
end