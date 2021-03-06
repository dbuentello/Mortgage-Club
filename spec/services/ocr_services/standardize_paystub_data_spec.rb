require "rails_helper"

describe OcrServices::StandardizePaystubData do
  let(:borrower) { FactoryGirl.create(:borrower) }
  let!(:ocr_data) { FactoryGirl.create(:ocr_with_full_data, borrower: borrower) }

  describe "#employer_name" do
    context "with similar name" do
      it "returns a right employer name" do
        ocr_data.employer_name_1 = "Mortgage Club"
        ocr_data.employer_name_2 = "Mortgage Clu"
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.employer_name).to eq("Mortgage Club")
      end
    end

    # context "with different name" do
    #   it "returns nil" do
    #     ocr_data.employer_name_1 = "Mortgage Club"
    #     ocr_data.employer_name_2 = "Lending Home"
    #     ocr_data.save
    #     service = OcrServices::StandardizePaystubData.new(borrower.id)

    #     expect(service.employer_name).to be_nil
    #   end
    # end
  end

  describe "#employer_full_address" do
    # it "calls #employer_address_line" do
    #   expect_any_instance_of(OcrServices::StandardizePaystubData).to receive(:employer_address_line).twice
    #   OcrServices::StandardizePaystubData.new(borrower.id).employer_full_address
    # end

    context "with first line and second line" do
      it "returns a full employer address" do
        ocr_data.address_first_line_1 = "227 Nguyen Van Cu"
        ocr_data.address_first_line_2 = "227 Nguyen Van Cu"
        ocr_data.address_second_line_1 = "Q5, TP.HCM"
        ocr_data.address_second_line_2 = "Q5, TP.HCM"
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.employer_full_address).to eq("227 Nguyen Van Cu Q5, TP.HCM")
      end
    end

    context "with only first line" do
      # it "returns a first line of employer address" do
      #   ocr_data.address_first_line_1 = "227 Nguyen Van Cu"
      #   ocr_data.address_first_line_2 = "227 Nguyen Van Cu"
      #   ocr_data.address_second_line_1 = "Ba Dinh, Hanoi"
      #   ocr_data.address_second_line_2 = "Q5, TP.HCM"
      #   ocr_data.save
      #   service = OcrServices::StandardizePaystubData.new(borrower.id)

      #   expect(service.employer_full_address).to eq("227 Nguyen Van Cu")
      # end
    end

    context "with only second line" do
      # it "returns a second line of employer address" do
      #   ocr_data.address_first_line_1 = "227 Nguyen Van Cu"
      #   ocr_data.address_first_line_2 = "92 Nguyen Huu Canh"
      #   ocr_data.address_second_line_1 = "Q5, TP.HCM"
      #   ocr_data.address_second_line_2 = "Q5, TP.HCM"
      #   ocr_data.save
      #   service = OcrServices::StandardizePaystubData.new(borrower.id)

      #   expect(service.employer_full_address).to eq("Q5, TP.HCM")
      # end
    end

    context "with different name" do
      # it "returns nils" do
      #   ocr_data.address_first_line_1 = "227 Nguyen Van Cu"
      #   ocr_data.address_first_line_2 = "92 Nguyen Huu Canh"
      #   ocr_data.address_second_line_1 = "Ba Dinh, Hanoi"
      #   ocr_data.address_second_line_2 = "Q5, TP.HCM"
      #   ocr_data.save
      #   service = OcrServices::StandardizePaystubData.new(borrower.id)

      #   expect(service.employer_full_address).to be_nil
      # end
    end
  end

  describe "#period" do
    before(:each) { Timecop.travel(Time.zone.local(2015, 11, 11)) }

    context "with semimonthly_frequency" do
      it "returns semimonthly" do
        end_of_month = Time.zone.now.end_of_month
        ocr_data.period_ending_1 = end_of_month
        ocr_data.period_ending_2 = end_of_month
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.period).to eq("semimonthly")
      end
    end

    # context "biweekly" do
    #   it "returns biweekly" do
    #     yesterday = Time.zone.now - 1.day
    #     ocr_data.period_ending_1 = yesterday
    #     ocr_data.period_beginning_1 = yesterday - 13.days
    #     ocr_data.period_ending_2 = yesterday
    #     ocr_data.period_beginning_2 = yesterday - 13.days
    #     ocr_data.save
    #     service = OcrServices::StandardizePaystubData.new(borrower.id)

    #     expect(service.period).to eq("biweekly")
    #   end
    # end

    context "with weekly" do
      it "returns weekly" do
        yesterday = Time.zone.now - 1.day
        ocr_data.period_ending_1 = yesterday
        ocr_data.period_beginning_1 = yesterday - 6.days
        ocr_data.period_ending_2 = yesterday
        ocr_data.period_beginning_2 = yesterday - 6.days
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.period).to eq("weekly")
      end
    end
  end

  describe "#salary" do
    context "with valid current salary" do
      it "returns max number between two salaries" do
        ocr_data.current_salary_1 = 123456
        ocr_data.current_salary_2 = 123456
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.salary).to eq([ocr_data.current_salary_1, ocr_data.current_salary_2].max.ceil)
      end
    end

    context "with invalid current salary" do
      before(:each) do
        ocr_data.current_salary_1 = 123456
        ocr_data.current_salary_2 = 1
      end

      context "with valid current earnings" do
        it "returns max number between two earnings" do
          ocr_data.current_earnings_1 = 123456
          ocr_data.current_earnings_2 = 123456
          ocr_data.save
          service = OcrServices::StandardizePaystubData.new(borrower.id)

          expect(service.salary).to eq([ocr_data.current_earnings_1, ocr_data.current_earnings_2].max.ceil)
        end
      end

      context "with invalid current earnings" do
        # it "returns nil" do
        #   ocr_data.current_earnings_1 = 123456
        #   ocr_data.current_earnings_2 = 1
        #   ocr_data.save
        #   service = OcrServices::StandardizePaystubData.new(borrower.id)

        #   expect(service.salary).to be_nil
        # end
      end
    end
  end

  describe "#ytd_salary" do
    context "with valid ytd salary" do
      it "returns max number between two ytd salaries" do
        ocr_data.ytd_salary_1 = 123456
        ocr_data.ytd_salary_2 = 123456
        ocr_data.save
        service = OcrServices::StandardizePaystubData.new(borrower.id)

        expect(service.ytd_salary).to eq([ocr_data.ytd_salary_1, ocr_data.ytd_salary_2].max.ceil)
      end
    end

    context "with invalid ytd salary" do
      # it "returns nil" do
      #   ocr_data.ytd_salary_1 = 123456
      #   ocr_data.ytd_salary_2 = 1
      #   ocr_data.save
      #   service = OcrServices::StandardizePaystubData.new(borrower.id)

      #   expect(service.ytd_salary).to be_nil
      # end
    end
  end
end
