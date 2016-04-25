require "rails_helper"
describe FacebookBotServices::SaveData do
  describe ".call" do
    context "with valid params" do
      let(:params) do
        {
          conversation_id: "3453453453",
          profile: {
            first_name: "John",
            last_name: "Doe",
            profile_pic: "https://example.com/john_doe.jpg"
          },
          parameters: {
            purpose: "purchase",
            down_payment: 50000,
            property_type: "single_family_home",
            usage: "primary_residence",
            zipcode: "95127",
            credit_score: 750,
            property_value: 500000
          },
          resolved_queries: [
            {
              question: "Great, what's the ZIP code?",
              answer: "95127",
              timestamp: 324234234
            },
            {
              question: "Awesome, how about purchase price?",
              answer: 500000,
              timestamp: 324234234
            }
          ]
        }
      end

      it "creates a new record" do
        expect { described_class.call(params) }.to change { FacebookData.count }.by(1)
      end

      it "creates a new record with correct format" do
        described_class.call(params)
        facebook_data = FacebookData.last
        expect(facebook_data.conversation_id).to eq("3453453453")
        expect(facebook_data.first_name).to eq("John")
        expect(facebook_data.last_name).to eq("Doe")
        expect(facebook_data.profile_pic).to eq("https://example.com/john_doe.jpg")
        expect(facebook_data.purpose).to eq("purchase")
        expect(facebook_data.down_payment).to eq(50000)
        expect(facebook_data.property_type).to eq("single_family_home")
        expect(facebook_data.usage).to eq("primary_residence")
        expect(facebook_data.zipcode).to eq("95127")
        expect(facebook_data.credit_score).to eq(750)
        expect(facebook_data.property_value).to eq(500000)
        expect(facebook_data.resolved_queries).to eq("[{:question=>\"Great, what's the ZIP code?\", :answer=>\"95127\", :timestamp=>324234234}, {:question=>\"Awesome, how about purchase price?\", :answer=>500000, :timestamp=>324234234}]")
      end
    end

    context "with invalid params" do
      it "does not create any records" do
        expect { described_class.call({}) }.to change { FacebookData.count }.by(0)
      end
    end
  end
end
