class Rate
  include HTTParty

  def self.get_rates
    Hash.from_xml(File.open("#{Rails.root}/public/quote_result.xml"))
  end
end
