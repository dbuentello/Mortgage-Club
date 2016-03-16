require "rails_helper"

describe PotentialUsersController do
  let(:potential_user_params) do
    file = File.new(Rails.root.join "spec", "files", "sample.pdf")
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: File.basename(file)
    )
    uploaded_file.content_type = "application/pdf"
    {email: "user@example.com", mortgage_statement: uploaded_file, send_as_email: true}
  end

  describe "#create" do
    context "with valid params" do
      it "creates new record" do
        expect { post :create, potential_user: potential_user_params }.to change(PotentialUser, :count).by 1
      end

      it "return a success message" do
        post :create, potential_user: potential_user_params
        expect(JSON.parse(response.body)["message"]).to eq("success")
      end
    end

    context "with invalid params" do
      it "returns error" do
        potential_user_params[:email] = nil

        post :create, potential_user: potential_user_params

        expect(JSON.parse(response.body)["email"]).to eq("This field is required")
      end
    end
  end
end
