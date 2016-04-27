require "rails_helper"

describe FredEconomicServices::CrawlAvgRates do
  describe ".call" do
    it "crawls data from Fred Economic Data 3 times to create new data" do
      VCR.use_cassette("get Fred Economic rate data") do
        expect(described_class).to receive(:crawl_data).exactly(3).times
        described_class.call
      end
    end
  end

  describe ".update" do
    it "also crawls from Fred Economic Data 3 times to create or update data" do
      VCR.use_cassette("get or update Fred Economic rate data") do
        expect(described_class).to receive(:crawl_data).exactly(3).times
        described_class.call
      end
    end
  end

  describe ".crawl_data" do
    let(:type) { "MORTGAGE30US" }
    before do
      @rates = {}
    end
    it "makes JSON received parse message" do
      VCR.use_cassette("crawls data on Fred Economic") do
        expect(JSON).to receive(:parse)
        described_class.crawl_data(type, nil, nil, @rates)
      end
    end
  end
end
