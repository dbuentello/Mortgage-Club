require "rails_helper"

describe GeneratePreparedLoanUrlTokenService do
  let(:loan) { FactoryGirl.create(:loan) }

  describe ".call" do
    it "returns an url" do
      allow_any_instance_of(Devise::TokenGenerator).to receive(:generate).and_return(["XfvCu1uSGfrosZMzvqcR", "encToken"])
      expect(described_class.call(loan)).to eq("http://localhost:4000/auth/secret/edit?reset_password_token=XfvCu1uSGfrosZMzvqcR")
    end
  end
end
