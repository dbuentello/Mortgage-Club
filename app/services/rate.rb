class Rate
  include HTTParty

  def self.get_rates
    Hash.from_xml(File.open("#{Rails.root}/public/quote_result.xml"))
  end

  def self.convert_text_to_boolean(text)
    text.downcase == 'true'
  end

end
