class Rate
  include HTTParty

  def self.get_rates
    rates = Hash.from_xml(File.open("#{Rails.root}/vendor/files/loan_sifter/products.xml"))
    rates['Result']['TransactionData']['PRODUCTS']['PRODUCT']
  end

  def self.get_fee
    # need to implement API call to LoanSifter here
    # for now, we just use this method as a mock
    fee = Hash.from_xml(File.open("#{Rails.root}/vendor/files/loan_sifter/fees.xml"))
    fee['Result']['TransactionData']['RESPAFees']['RESPAFee']
  end

  def self.convert_text_to_boolean(text)
    text.downcase == 'true'
  end

end
