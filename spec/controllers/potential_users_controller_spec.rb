require "rails_helper"

describe PotentialUsersController do
  before do
    file = File.new(Rails.root.join "spec", "files", "sample.pdf")
    @uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: File.basename(file),
    )
    @uploaded_file.content_type = "application/pdf"
    @potential_user_params = { email: "user@example.com", mortgage_statement: @uploaded_file }
  end

  describe "#create" do
    context "creates success potential user with valid params" do
      it "changes potential_users db table by 1 record" do
        expect{ post :create, potential_user: @potential_user_params}.to change(PotentialUser, :count).by 1
      end
      it "responses with success message" do
        post :create, potential_user: @potential_user_params
        expect(JSON.parse(response.body)["message"]).to eq "success"
      end
    end

    context "fails to create potential user with invalid params" do
      it "returns error" do
        @potential_user_params[:email] = nil

        post :create, potential_user: @potential_user_params
        expect(JSON.parse(response.body)["message"]).to eq "error"
      end
    end

  end
end