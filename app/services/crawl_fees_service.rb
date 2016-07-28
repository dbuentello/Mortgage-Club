require "capybara"
require "capybara/poltergeist"

class CrawlFeesService
  attr_accessor :crawler, :fees, :params

  def initialize(args)
    @crawler = set_up_crawler
    @fees = []
    @params = args
  end

  def call
    go_to_ort
    fill_input_data
    click_submit
    get_data
    close_crawler

    @fees
  end

  def go_to_ort
    crawler.visit("https://www.ortconline.com/Web2/ProductsServices/InformationServices/RateFeeCalc/Default.aspx")
  end

  def fill_input_data
    crawler.fill_in("_ctl0_PageContent_PropertyCityList_Text", with: params[:city])
    sleep(3)
    crawler.select(params[:zip], from: "_ctl0_PageContent_PropertyZipList")
    crawler.fill_in("_ctl0_PageContent_SalesPrice", with: params[:sales_price])
    crawler.fill_in("_ctl0_PageContent_LoanAmount", with: params[:loan_amount])
    crawler.check("_ctl0_PageContent_EndorsementsRepeater__ctl4_EndorsementCheckbox")
    crawler.check("_ctl0_PageContent_InHouseNotaryCheckbox")
  end

  def click_submit
    crawler.find("input[id=_ctl0_PageContent_Submit]").trigger("click")

    # selenium
    # crawler.find("input[id=_ctl0_PageContent_Submit]").click
  end

  def get_data
    fees_c = []
    table_c = crawler.find_by_id("_ctl0_PageContent_SectionCTable")
    section_c = table_c.all("tr")
    section_c.each do |element|
      td = element.all("td")
      next if td.empty?

      fees_c << {
        "Description": remove_total(td[0].text),
        "FeeAmount": remove_currency(td[1].text),
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }
    end

    fees_e = []
    table_e = crawler.find_by_id("_ctl0_PageContent_SectionETable")
    section_e = table_e.all("tr")
    section_e.each do |element|
      td = element.all("td")
      next if td.empty?

      fees_e << {
        "Description": remove_total(td[0].text),
        "FeeAmount": remove_currency(td[1].text),
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }
    end

    fees_h = []
    table_h = crawler.find_by_id("_ctl0_PageContent_SectionHTable")
    section_h = table_h.all("tr")
    section_h.each do |element|
      td = element.all("td")
      next if td.empty? || td.size <= 1

      fees_h << {
        "Description": remove_total(td[0].text),
        "FeeAmount": remove_currency(td[1].text),
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }
    end

    fees_c.reject! { |x| x[:Description] == "" }
    fees_e.reject! { |x| x[:Description] == "" }
    fees_h.reject! { |x| x[:Description] == "" }

    @fees << {
      "Description": "Services you can shop for",
      "FeeAmount": fees_c.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_c
    }

    @fees << {
      "Description": "Taxes and other government fees",
      "FeeAmount": fees_e.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_e
    }

    @fees << {
      "Description": "Other",
      "FeeAmount": fees_h.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_h
    }
  rescue
    []
  end

  def remove_total(label)
    return "" if label.empty?

    if label.index("8.1-06")
      label[label.index("8.1-06") + 7..-1]
    else
      label = label.delete("*")
      label[0..label.index("(").to_i - 2]
    end
  end

  def remove_currency(number)
    return 0 if number.empty?

    if number.index("seller paid")
      0
    else
      number.gsub(/[^\d\.]/, '').to_f
    end
  end

  def set_up_crawler
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(
        app,
        js_errors: true,
        timeout: 40,
        phantomjs_options: ["--load-images=no", "--ignore-ssl-errors=yes"],
        inspector: true
      )
    end

    Capybara.default_max_wait_time = 30
    Capybara::Session.new(:poltergeist)
    # Capybara::Session.new(:selenium)
  end

  def close_crawler
    crawler.driver.quit
  end
end
