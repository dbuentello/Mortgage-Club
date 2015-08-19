require 'rails_helper'

describe BorrowerUploaderController do
  # ignore GET download actions because they use aws methods, which is not available in test environment
  context "upload" do
    include_context 'signed in as borrower user'

    describe "POST w2" do
      it "returns warning when file is blank" do
        post :w2, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('File not found')
        expect(user.borrower.first_w2).to be_nil
        expect(user.borrower.second_w2).to be_nil
      end

      it "returns warning when order is blank" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :w2, id: user.borrower.id, file: file, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(user.borrower.first_w2).to be_nil
        expect(user.borrower.second_w2).to be_nil
      end

      it "creates file when all params are right" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :w2, id: user.borrower.id, file: file, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{user.borrower.first_name}")
        expect(user.borrower.first_w2).to be_truthy
        expect(user.borrower.second_w2).to be_nil
      end
    end

    describe "POST paystub" do
      it "returns warning when file is blank" do
        post :paystub, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('File not found')
      end

      it "returns warning when order is blank" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :paystub, id: user.borrower.id, file: file, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(user.borrower.first_paystub).to be_nil
        expect(user.borrower.second_paystub).to be_nil
      end

      it "creates file when all params are right" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :paystub, id: user.borrower.id, file: file, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{user.borrower.first_name}")
        expect(user.borrower.first_paystub).to be_truthy
        expect(user.borrower.second_paystub).to be_nil
      end
    end

    describe "POST bank_statement" do
      it "returns warning when file is blank" do
        post :bank_statement, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('File not found')
      end

      it "returns warning when order is blank" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :bank_statement, id: user.borrower.id, file: file, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(user.borrower.first_bank_statement).to be_nil
        expect(user.borrower.second_bank_statement).to be_nil
      end

      it "creates file when all params are right" do
        file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

        post :bank_statement, id: user.borrower.id, file: file, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{user.borrower.first_name}")
        expect(user.borrower.first_bank_statement).to be_truthy
        expect(user.borrower.second_bank_statement).to be_nil
      end
    end
  end

  context "remove" do
    describe "DELETE remove_w2" do
      let(:borrower) { FactoryGirl.create(:borrower_with_w2, :with_user) }
      let(:user) { borrower.user }

      it "returns warning when file cannot be found" do
        login_with user

        delete :remove_w2, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(borrower.reload.first_w2).to be_truthy
        expect(borrower.reload.second_w2).to be_truthy
      end

      it "removes file successfully when all params are right" do
        login_with user

        delete :remove_w2, id: user.borrower.id, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Done removed')
        expect(borrower.reload.first_w2).to be_nil
        expect(borrower.reload.second_w2).to be_truthy
      end
    end

    describe "DELETE remove_paystub" do
      let(:borrower) { FactoryGirl.create(:borrower_with_paystub, :with_user) }
      let(:user) { borrower.user }

      it "returns warning when file cannot be found" do
        login_with user

        delete :remove_paystub, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(borrower.reload.first_paystub).to be_truthy
        expect(borrower.reload.second_paystub).to be_truthy
      end

      it "removes file successfully when all params are right" do
        login_with user

        delete :remove_paystub, id: user.borrower.id, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Done removed')
        expect(borrower.reload.first_paystub).to be_nil
        expect(borrower.reload.second_paystub).to be_truthy
      end
    end

    describe "DELETE remove_bank_statement" do
      let(:borrower) { FactoryGirl.create(:borrower_with_bank_statement, :with_user) }
      let(:user) { borrower.user }

      it "returns warning when file cannot be found" do
        login_with user

        delete :remove_bank_statement, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
        expect(borrower.reload.first_bank_statement).to be_truthy
        expect(borrower.reload.second_bank_statement).to be_truthy
      end

      it "removes file successfully when all params are right" do
        login_with user

        delete :remove_bank_statement, id: user.borrower.id, order: '1', format: :json

        expect(JSON.parse(response.body)["message"]).to eq('Done removed')
        expect(borrower.reload.first_bank_statement).to be_nil
        expect(borrower.reload.second_bank_statement).to be_truthy
      end
    end
  end

  context "download" do
    describe "GET download_w2" do
      it "returns warning when file cannot be found" do
        user = FactoryGirl.create(:borrower_user)
        borrower = FactoryGirl.create(:borrower_with_w2, user: user)

        login_with user

        get :download_w2, id: user.borrower.id, format: :json

        expect(JSON.parse(response.body)["message"]).to eq("You don't have this file yet. Try to upload it!")
      end

      # we cannot test for aws service in testing environment
    end
  end

end
