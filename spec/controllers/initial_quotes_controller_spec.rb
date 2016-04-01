require "rails_helper"

describe InitialQuotesController do
  describe "#slack_webhook" do
    context "when request is invalid" do
      it "returns status 401" do
        post :slack_webhook

        expect(response.status).to eq(401)
      end
    end

    context "when request is valid" do
      before(:each) { request.headers["HTTP_MORTGAGECLUB_SLACK"] = "MCsLACK!" }

      context "when quotes are present" do
        it "renders initial quote's url" do
          allow_any_instance_of(LoanTekServices::GetQuotesInfoForSlackBot).to receive(:call).and_return(true)
          allow_any_instance_of(LoanTekServices::GetQuotesInfoForSlackBot).to receive(:query_content).and_return("lorem ipsum")
          allow_any_instance_of(LoanTekServices::GetQuotesInfoForSlackBot).to receive(:quotes_summary).and_return("This is quote summary. ")

          post :slack_webhook, initial_quote: {result: {}}

          expect(JSON.parse(response.body)["speech"]).to eq("This is quote summary. You can see your quotes at http://test.host/quotes/#{QuoteQuery.last.code_id}")
        end
      end

      context "when quotes are empty" do
        it "renders a sorry message" do
          allow_any_instance_of(LoanTekServices::GetQuotesInfoForSlackBot).to receive(:call).and_return(false)

          post :slack_webhook, initial_quote: {result: {}}

          expect(JSON.parse(response.body)["speech"]).to eq("We're sorry, there aren't any quotes matching your needs.")
        end
      end
    end
  end
end
