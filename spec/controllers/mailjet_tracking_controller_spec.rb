# require "rails_helper"

# describe MailjetTrackingController do
#   let(:loan) { FactoryGirl.create(:loan) }

#   describe "#track" do
#     context "valid" do
#       it "renders nothing" do
#         post :track

#         expect(response.status).to eq(200)
#       end

#       it "calls valid function" do
#         expect_any_instance_of(described_class).to receive(:valid?)

#         post :track
#       end

#       it "updates loan's status" do
#         post :track, event: "open", "CustomID" => "Lock Loan - #{loan.id}"

#         loan.reload
#         expect(loan.read?).to be_truthy
#       end
#     end

#     context "invalid" do
#       it "does not change loan's status" do
#         post :track, event: "fake-event", "CustomID" => "Lock Loan - #{loan.id}"

#         expect(loan.read?).to be_falsey
#       end
#     end
#   end
# end
