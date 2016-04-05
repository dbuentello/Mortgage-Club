require "rails_helper"

describe SlackWebhooksController do
  describe "#receive" do
    context "when request is invalid" do
      it "returns status 401" do
        post :receive

        expect(response.status).to eq(401)
      end
    end

    context "when request is valid" do
      before(:each) { request.headers["HTTP_MORTGAGECLUB_SLACK"] = "MCsLACK!" }

      context "when quotes are present" do
        it "returns status 200" do
          post :receive, initial_quote: {result: {}}

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
