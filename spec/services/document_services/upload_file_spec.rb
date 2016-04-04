require 'rails_helper'

describe DocumentServices::UploadFile do
  let(:closing) { FactoryGirl.create(:closing) }
  let(:user) { FactoryGirl.create(:user) }

  context "with valid params" do
    let!(:service) do
      file = File.new(Rails.root.join "spec", "files", "sample.pdf")
      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: file,
        filename: File.basename(file)
      )
      uploaded_file.content_type = "application/pdf" # it's so weird

      described_class.new(
        subject_type: "Closing",
        subject_id: closing.id,
        document_type: "closing_disclosure",
        current_user: user,
        params: {
          original_filename: "closing disclosure.pdf",
          file: uploaded_file,
          description: "This is a closing disclosure"
        }
      )
    end

    it "returns a document after completing service" do
      expect(service.call).to be_a(Document)
    end

    describe "uploads a new document" do
      before(:each) { @document = service.call }

      it "creates a new document record" do
        expect(Document.count).to eq(1)
      end

      it "uploads a document successfully" do
        expect(PDF_MINE_TYPES).to include(@document.attachment_content_type)
        expect(@document.description).to eq("This is a closing disclosure")
      end
    end

    context "when document type is other document" do
      context "when subjectable is borrower" do
        let!(:borrower) { FactoryGirl.create(:borrower) }

        it "creates a new borrower document" do
          service.args[:subject_type] = "Borrower"
          service.args[:subject_id] = borrower.id
          service.args[:document_type] = "other_borrower_report"

          service.call

          expect(borrower.documents.size).to eq(1)
        end
      end

      context "when subjectable is loan" do
        let(:loan) { FactoryGirl.create(:loan) }

        it "creates a new loan document" do
          service.args[:subject_type] = "Loan"
          service.args[:subject_id] = loan.id
          service.args[:document_type] = "other_loan_report"

          service.call

          expect(loan.documents.size).to eq(1)
        end
      end

      context "when subjectable is closing" do
        let(:closing_other_documents) { FactoryGirl.create(:closing) }

        it "creates a new closing document" do
          service.args[:subject_type] = "Closing"
          service.args[:subject_id] = closing_other_documents.id
          service.args[:document_type] = "other_closing_report"

          service.call

          expect(closing_other_documents.documents.size).to eq(1)
        end
      end

      context "when subjectable is property" do
        let(:property) { FactoryGirl.create(:property) }

        it "creates a new property document" do
          service.args[:subject_type] = "Property"
          service.args[:subject_id] = property.id
          service.args[:document_type] = "other_property_report"

          service.call

          expect(property.documents.size).to eq(1)
        end
      end
    end
  end

  context "with invalid params" do
    before(:each) do
      @args = {
        subject_type: "Closing",
        subject_id: closing.id,
        document_type: "closing_disclosure",
        current_user: user,
        params: {
          description: "This is a closing disclosure"
        }
      }
    end

    it "returns false if subject does not exist" do
      @args[:subject_id] = "non-existent-id"
      expect(described_class.new(@args).call).to be_falsey
    end

    it "raises NameError if subject_type class name is invalid" do
      @args[:subject_type] = "FakeClass"
      expect { raise described_class.new(@args).call }.to raise_error(NameError)
    end
  end
end
