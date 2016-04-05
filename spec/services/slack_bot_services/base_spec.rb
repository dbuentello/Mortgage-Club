require "rails_helper"

module SlackBotServices
  describe Base do
    describe "#call" do
      context "with service" do
        it "calls a SlackBot service" do
          allow_any_instance_of(described_class).to receive(:conversation).and_return("get-quotes")
          expect(SlackBotServices::GetInfoOfQuotes).to receive(:call)

          described_class.new({}).call
        end
      end

      context "without service" do
        it "returns nil" do
          expect(described_class.new({}).call).to be_nil
        end
      end
    end

    describe "#select_service" do
      context "with get-quotes" do
        it "returns correct class name" do
          allow_any_instance_of(described_class).to receive(:conversation).and_return("get-quotes")
          expect(described_class.new({}).select_service).to eq(SlackBotServices::GetInfoOfQuotes)
        end
      end

      context "with create-account" do
        it "returns correct class name" do
          allow_any_instance_of(described_class).to receive(:conversation).and_return("create-account")
          expect(described_class.new({}).select_service).to eq(SlackBotServices::NotifySignUp)
        end
      end

      context "with create-rate-alert" do
        it "returns correct class name" do
          allow_any_instance_of(described_class).to receive(:conversation).and_return("create-rate-alert")
          expect(described_class.new({}).select_service).to eq(SlackBotServices::NotifyRateAlert)
        end
      end
    end
  end
end
