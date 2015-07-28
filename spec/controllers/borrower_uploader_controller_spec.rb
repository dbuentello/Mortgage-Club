require 'rails_helper'

describe BorrowerUploaderController do
  # ignore GET download actions because they use aws methods, which is not available in test environment

  describe "POST w2" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :w2, id: loan.user.borrower.id, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
      expect(loan.user.borrower.first_w2).to be_nil
      expect(loan.user.borrower.second_w2).to be_nil
    end

    it "should return warning when order is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :w2, id: loan.user.borrower.id, file: file, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
      expect(loan.user.borrower.first_w2).to be_nil
      expect(loan.user.borrower.second_w2).to be_nil
    end

    it "should create file when all params are right" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :w2, id: loan.user.borrower.id, file: file, order: '1', format: :json

      expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{loan.user.borrower.first_name}")
      expect(loan.user.borrower.first_w2).to be_truthy
      expect(loan.user.borrower.second_w2).to be_nil
    end
  end

  describe "POST paystub" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :paystub, id: loan.user.borrower.id, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
    end

    it "should return warning when order is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :paystub, id: loan.user.borrower.id, file: file, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
      expect(loan.user.borrower.first_paystub).to be_nil
      expect(loan.user.borrower.second_paystub).to be_nil
    end

    it "should create file when all params are right" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :paystub, id: loan.user.borrower.id, file: file, order: '1', format: :json

      expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{loan.user.borrower.first_name}")
      expect(loan.user.borrower.first_paystub).to be_truthy
      expect(loan.user.borrower.second_paystub).to be_nil
    end
  end

  describe "POST bank_statement" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :bank_statement, id: loan.user.borrower.id, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
    end

    it "should return warning when order is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :bank_statement, id: loan.user.borrower.id, file: file, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('Missing param order')
      expect(loan.user.borrower.first_bank_statement).to be_nil
      expect(loan.user.borrower.second_bank_statement).to be_nil
    end

    it "should create file when all params are right" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      file = File.new(Rails.root.join 'spec', 'files', 'sample.png')

      post :bank_statement, id: loan.user.borrower.id, file: file, order: '1', format: :json

      expect(JSON.parse(response.body)["message"]).to eq("Sucessfully for #{loan.user.borrower.first_name}")
      expect(loan.user.borrower.first_bank_statement).to be_truthy
      expect(loan.user.borrower.second_bank_statement).to be_nil
    end
  end

end
