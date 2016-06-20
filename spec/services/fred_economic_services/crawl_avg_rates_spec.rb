require "rails_helper"

describe FredEconomicServices::CrawlAvgRates do
  describe ".call" do
    it "crawls data from Fred Economic Data 3 times" do
      VCR.use_cassette("get Fred Economic rate data") do
        expect(described_class).to receive(:crawl_data).exactly(3).times
        described_class.call
      end
    end

    it "saves data to Fred Economic" do
      VCR.use_cassette("get Fred Economic rate data") do
        expect { described_class.call }.to change(FredEconomic, :count).by(2353)
      end
    end
  end

  describe ".update" do
    it "crawls from Fred Economic Data 3 times" do
      VCR.use_cassette("get or update Fred Economic rate data") do
        expect(described_class).to receive(:crawl_data).exactly(3).times
        described_class.update
      end
    end

    it "finds or creates Fred Economic data" do
      # VCR.use_cassette("finds or creates Fred Economic rate data") do
      #   described_class.call
      #   expect { described_class.update }.to change(FredEconomic, :count).by(0)
      # end
    end
  end

  describe ".crawl_data" do
    let(:type) { "MORTGAGE30US" }

    it "calls JSON.parse" do
      VCR.use_cassette("crawls data on Fred Economic") do
        expect(JSON).to receive(:parse)
        described_class.crawl_data(type, nil, nil, {})
      end
    end
  end
end
