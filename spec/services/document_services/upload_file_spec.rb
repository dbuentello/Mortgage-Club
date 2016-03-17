require 'rails_helper'

describe DocumentServices::UploadFile do
  let(:closing) { FactoryGirl.create(:closing) }
  let(:user) { FactoryGirl.create(:user) }

  context "with valid params" do
    let(:service) do
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

      it "sets file name by standard format" do
        expect(@document.attachment_file_name).to eq("Closing-#{closing.id}.pdf")
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
