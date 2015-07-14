module NumbersHelper

  # use for displaying only, not from Rails ActionView Helper
  def number_with_precision(number, options={})
    options[:precision] ||= 2

    "%.#{options[:precision]}f" % number
  end
end
