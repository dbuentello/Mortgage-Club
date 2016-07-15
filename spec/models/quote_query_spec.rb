require "rails_helper"

describe QuoteQuery do
  let(:quote_query) { FactoryGirl.build(:quote_query) }

  it { should validate_presence_of(:query) }

  it "has a valid factory" do
    quote_query.valid?
    expect(quote_query).to be_valid
  end
end
