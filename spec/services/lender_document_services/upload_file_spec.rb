require "rails_helper"

describe LenderDocumentServices::UploadFile do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:lender_template) { FactoryGirl.create(:lender_template) }
  let(:user) { FactoryGirl.create(:user) }

  context "with normal template" do
    before(:each) do
      args = {
        file: uploaded_file,
        template: lender_template,
        description: "This is a description",
        loan: loan,
        user: user
      }
      @service = described_class.new(args)
    end

    context "when document is not existing" do
      it "creates new document" do
        expect { @service.call }.to change { LenderDocument.count }.from(0).to(1)
      end
    end

    context "when document is existing" do
      let!(:lender_document) { FactoryGirl.create(:lender_document, loan: loan, lender_template: lender_template) }

      it "updates document" do
        expect { @service.call }.not_to change { LenderDocument.count }
      end
    end
  end

  context "with other template" do
    let(:other_template) { FactoryGirl.create(:lender_template, is_other: true) }
    let!(:other_document) { FactoryGirl.create(:lender_document, loan: loan, lender_template: other_template) }

    it "creates new document" do
      args = {
        file: uploaded_file,
        template: other_template,
        description: "This is a description",
        loan: loan,
        user: user
      }
      service = described_class.new(args)

      expect { service.call }.to change { LenderDocument.count }.from(1).to(2)
    end
  end
end

def uploaded_file
  file = File.new(Rails.root.join "spec", "files", "sample.pdf")
  uploaded_file = ActionDispatch::Http::UploadedFile.new(
    tempfile: file,
    filename: File.basename(file)
  )
  uploaded_file.content_type = "application/pdf"
  uploaded_file
end
