require "rails_helper"

describe CompletedLoanServices::TabDocuments do
  let!(:loan) { FactoryGirl.create(:loan_with_secondary_borrower) }

  before(:each) do
    @service = CompletedLoanServices::TabDocuments.new({
      borrower: loan.borrower,
      secondary_borrower: loan.secondary_borrower
    })
  end

  context "with secondary borrower nil" do
    before do
      @service.secondary_borrower = nil
    end

    context "with borrower self employed" do
      let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }

      before do
        @service.borrower = borrower
      end

      it "returns false with first personal tax return nil" do
        borrower.documents.find_by(document_type: "first_personal_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second personal tax return nil" do
        borrower.documents.find_by(document_type: "second_personal_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with first business tax return nil" do
        borrower.documents.find_by(document_type: "first_business_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second business tax return nil" do
        borrower.documents.find_by(document_type: "second_business_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with first bank statement nil" do
        borrower.documents.find_by(document_type: "first_bank_statement").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second bank statement nil" do
        borrower.documents.find_by(document_type: "second_bank_statement").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns true with borrower documents valid" do
        expect(@service.call).to be_truthy
      end
    end

    context "with borrower not self employed" do
      let!(:borrower) { FactoryGirl.create(:borrower_with_documents_not_self_employed, loan: loan) }

      before do
        @service.borrower = borrower
      end

      it "returns false with first w2 nil" do
        borrower.documents.find_by(document_type: "first_w2").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second w2 nil" do
        borrower.documents.find_by(document_type: "second_w2").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with first paystub nil" do
        borrower.documents.find_by(document_type: "first_paystub").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second paystub nil" do
        borrower.documents.find_by(document_type: "second_paystub").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with first federal tax return nil" do
        borrower.documents.find_by(document_type: "first_federal_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second federal tax return nil" do
        borrower.documents.find_by(document_type: "second_federal_tax_return").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with first bank statement nil" do
        borrower.documents.find_by(document_type: "first_bank_statement").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns false with second bank statement nil" do
        borrower.documents.find_by(document_type: "second_bank_statement").destroy
        @service.borrower = borrower
        expect(@service.call).to be_falsey
      end

      it "returns true with borrower documents valid" do
        expect(@service.call).to be_truthy
      end
    end
  end

  context "with secondary borrower not nil" do
    describe "checks borrower completed" do
      context "with borrower self employed" do
        let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }

        it "returns true with valid values" do
          @service.borrower = borrower
          expect(@service.not_jointly_document_completed?(@service.borrower)).to be_truthy
        end
      end

      context "with borrower not self employed" do
        let!(:borrower) { FactoryGirl.create(:borrower_with_documents_not_self_employed, loan: loan) }

        it "returns true with valid values" do
          @service.borrower = borrower
          expect(@service.not_jointly_document_completed?(@service.borrower)).to be_truthy
        end
      end
    end

    describe "checks secondary borrower completed" do
      context "with taxes jointly" do
        context "with self employed" do
          let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }
          let!(:secondary_borrower) { FactoryGirl.create(:borrower_with_documents_self_employed_taxes_joinly, loan: loan) }

          before do
            @service.borrower = borrower
            @service.secondary_borrower = secondary_borrower
          end

          it "returns false with first business tax return nil" do
            secondary_borrower.documents.find_by(document_type: "first_business_tax_return").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with second business tax return nil" do
            secondary_borrower.documents.find_by(document_type: "second_business_tax_return").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with first bank statement nil" do
            secondary_borrower.documents.find_by(document_type: "first_bank_statement").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with second bank statement nil" do
            secondary_borrower.documents.find_by(document_type: "second_bank_statement").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns true with valid values" do
            expect(@service.call).to be_truthy
          end
        end

        context "with not self employed" do
          let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }
          let!(:secondary_borrower) { FactoryGirl.create(:borrower_with_documents_not_self_employed_taxes_joinly, loan: loan) }

          before do
            @service.borrower = borrower
            @service.secondary_borrower = secondary_borrower
          end

          it "returns false with first w2 nil" do
            secondary_borrower.documents.find_by(document_type: "first_w2").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with second w2 nil" do
            secondary_borrower.documents.find_by(document_type: "second_w2").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with first paystub nil" do
            secondary_borrower.documents.find_by(document_type: "first_paystub").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with second paystub nil" do
            secondary_borrower.documents.find_by(document_type: "second_paystub").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with first bank statement nil" do
            secondary_borrower.documents.find_by(document_type: "first_bank_statement").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end

          it "returns false with second bank statement nil" do
            secondary_borrower.documents.find_by(document_type: "second_bank_statement").destroy
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_falsey
          end
          it "return trues with valid values" do
            @service.borrower.is_file_taxes_jointly = true
            expect(@service.call).to be_truthy
          end
        end
      end

      context "with taxes not jointly" do
        context "with self employed" do
          let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }
          let!(:secondary_borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }

          it "returns true with valid values" do
            @service.borrower = borrower
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_truthy
          end
        end

        context "with not self employed" do
          let!(:borrower) { FactoryGirl.create(:borrower_with_documents_self_employed, loan: loan) }
          let!(:secondary_borrower) { FactoryGirl.create(:borrower_with_documents_not_self_employed, loan: loan) }

          it "return trues with valid values" do
            @service.borrower = borrower
            @service.secondary_borrower = secondary_borrower
            expect(@service.call).to be_truthy
          end
        end
      end
    end
  end
end
