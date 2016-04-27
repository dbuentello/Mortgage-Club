require "rails_helper"

describe LoanTekServices::SendRequestToLoanTek do
  describe ".client_id" do
    it "returns loan tek client id" do
      expect(described_class.client_id).to eq(ENV["LOANTEK_CLIENT_ID"])
    end
  end

  describe ".user_id" do
    it "returns loan tek user id" do
      expect(described_class.user_id).to eq(ENV["LOANTEK_USER_ID"])
    end
  end

  describe ".lock_period" do
    it "returns lock period in days" do
      expect(described_class.lock_period).to eq(30)
    end
  end

  describe ".execution_method" do
    it "returns 2 as By Rate option" do
      expect(described_class.execution_method).to eq(2)
    end
  end

  describe ".quoting_channel" do
    it "returns LoanTek channel(channel index is 3)" do
      expect(described_class.quoting_channel).to eq(3)
    end
  end

  describe ".loan_programs_of_interest" do
    it "returns array of loan propgrams" do
      expect(described_class.loan_programs_of_interest).to eq([1, 2, 3])
    end
  end

  describe ".quote_types_to_return" do
    it "returns an array of quote types [-1, 0, 1]" do
      expect(described_class.quote_types_to_return).to eq([-1, 0, 1])
    end
  end
end
