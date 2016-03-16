require "rails_helper"

describe LoanMembers::LenderDocumentsController do
  include_context 'signed in as loan member user'
  let(:loan) { FactoryGirl.create(:loan) }
  let(:lender) { FactoryGirl.create(:lender) }
  let(:document) { FactoryGirl.create(:lender_document, loan: loan, lender_template: lender.lender_templates.last) }
  let!(:loans_members_association) { FactoryGirl.create(:loans_members_association, loan_member: user.loan_member, loan: loan) }

  before(:each) { allow(Amazon::GetUrlService).to receive(:call).and_return("http://google.com") }

  describe "#create" do
    before(:each) do
      file = File.new(Rails.root.join "spec", "files", "sample.pdf")
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: file,
        filename: File.basename(file),
      )
      @uploaded_file.content_type = "application/pdf"
    end

    context "successful" do
      it "creates a new document" do
        expect do
          post :create, loan_id: loan.id,
                        template_id: lender.lender_templates.last,
                        description: "This is a description",
                        file: @uploaded_file,
                        format: :json
        end.to change { LenderDocument.count }.from(0).to(1)
      end

      it "renders document's info" do
        post :create, loan_id: loan.id,
                      template_id: lender.lender_templates.last,
                      description: "This is a description",
                      file: @uploaded_file,
                      format: :json

        expectation = {
          lender_document: LoanMembers::LenderDocumentPresenter.new(loan.lender_documents.last).show,
          lender_documents: LoanMembers::LenderDocumentsPresenter.new(loan.lender_documents).show,
          download_url: download_loan_members_lender_document_path(loan.lender_documents.last),
          remove_url: loan_members_lender_document_path(loan.lender_documents.last),
          message: "Created successfully"
        }.to_json

        expect(JSON.parse(response.body)).to eq(JSON.parse(expectation))
      end
    end

    context "missing lender template id" do
      it "renders error message" do
        post :create, loan_id: loan.id,
                      description: "This is a description",
                      file: @uploaded_file,
                      format: :json

        expect(JSON.parse(response.body)["message"]).to eq("Template is not found")
      end
    end

    context "save failed" do
      it "renders error message" do
        allow_any_instance_of(LenderDocument).to receive(:save).and_return(false)

        post :create, loan_id: loan.id,
                      template_id: lender.lender_templates.last,
                      file: @uploaded_file,
                      format: :json

        expect(JSON.parse(response.body)["message"]).to eq("Failed to upload document")
      end
    end
  end

  describe "#download" do
    it "redirects to downloadable url" do
      get :download, id: document.id
      expect(response).to redirect_to("http://google.com")
    end
  end

  describe "#destroy" do
    context "successful" do
      before(:each) { delete :destroy, id: document.id }

      it "removes a document" do
        expect(LenderDocument.count).to eq(0)
      end

      it "renders successful message" do
        expect(JSON.parse(response.body)["message"]).to eq("Removed it sucessfully")
      end
    end

    context "failed" do
      it "renders error message" do
        allow_any_instance_of(LenderDocument).to receive(:destroy).and_return(false)

        delete :destroy, id: document.id

        expect(JSON.parse(response.body)["message"]).to eq("Remove file failed")
      end
    end
  end

  describe "#set_document" do
    it "sets document which was found to an instance variable" do
      get :download, id: document.id

      expect(assigns(:document)).to eq(document)
    end

    context "not found file" do
      it "renders error message" do
        get :download, id: "fake-id"

        expect(JSON.parse(response.body)["message"]).to eq("File is not found")
      end
    end
  end
end
