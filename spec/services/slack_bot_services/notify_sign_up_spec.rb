require "rails_helper"

describe SlackBotServices::NotifySignUp do
  describe ".call" do
    before(:each) do
      @sign_up_info = {
        "result" => {
          "contexts" => [
            "parameters" => {
              "purpose" => "refinance",
              "email" => "hoa@example.com"
            }
          ]
        }
      }

    end
    it "notifies loan member about Sign up information" do
      # message_delivery = instance_double(ActionMailer::MessageDelivery)
      # expect(MortgageBotMailer).to receive(:inform_sign_up_information)
      described_class.call(@sign_up_info)
      expect(Delayed::Job.count).to eq(1)
    end
  end
end
