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
    if params[:loan_purpose == 1]
      go_to_ort
      fill_input_data
      click_submit
      get_data
      close_crawler
    else
      get_data_for_refinance
    end

    @fees
  end

  def go_to_ort
    crawler.visit("https://www.ortconline.com/Web2/ProductsServices/InformationServices/RateFeeCalc/Default.aspx")
  end

  def fill_input_data
    crawler.fill_in("_ctl0_PageContent_PropertyCityList_Text", with: params[:city])
    crawler.execute_script("document.getElementById('_ctl0_PageContent_PropertyCityList_Text').onchange()")
    sleep(2)

    crawler.execute_script("
      document.getElementById('_ctl0_PageContent_PropertyZipCell').remove();
      var element = document.createElement('input');
      element.type = 'hidden';
      element.value = '#{params[:zip]}';
      element.name = '_ctl0:PageContent:PropertyZipList';
      document.getElementById('aspnetForm').appendChild(element);
    ")

    crawler.fill_in("_ctl0_PageContent_SalesPrice", with: params[:sales_price]) if params[:loan_purpose] == 1
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
    begin
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
    rescue
      fees_c
    end

    fees_e = []
    begin
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
    rescue
      fees_e
    end

    fees_h = []
    begin
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
    rescue
      fees_h
    end

    fees_c.reject! { |x| x[:Description] == "" || x[:FeeAmount] == 0 }
    fees_e.reject! { |x| x[:Description] == "" || x[:FeeAmount] == 0 }
    fees_h.reject! { |x| x[:Description] == "" || x[:FeeAmount] == 0 }

    @fees << {
      "Description": "Services you can shop for",
      "FeeAmount": fees_c.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_c
    }

    @fees << {
      "Description": "Taxes and other gotv fees",
      "FeeAmount": fees_e.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_e
    }

    @fees << {
      "Description": "Other",
      "FeeAmount": fees_h.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_h
    }
  end

  def get_data_for_refinance
    fees_c = []
    fees_e = []

    fees_c << {
      "Description": "Title - Lender's Title Policy",
      "FeeAmount": get_lender_title_policy,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    fees_c << {
      "Description": "Title - Notary Fee",
      "FeeAmount": 120.0,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    fees_c << {
      "Description": "Title - Recording Service Fee",
      "FeeAmount": 20.0,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    fees_c << {
      "Description": "Title - Settlement Agent Fee",
      "FeeAmount": get_settlement_agent_fee,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    fees_e << {
      "Description": "Recording Fees",
      "FeeAmount": 95.0,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    @fees << {
      "Description": "Services you can shop for",
      "FeeAmount": fees_c.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_c
    }

    @fees << {
      "Description": "Taxes and other gotv fees",
      "FeeAmount": fees_e.map { |x| x[:FeeAmount] }.sum,
      "Fees": fees_e
    }
  end

  def get_lender_title_policy
    if params[:loan_amount] <= 250_000.0
      450.0
    elsif params[:loan_amount] <= 500_000.0
      645.0
    elsif params[:loan_amount] <= 750_000.0
      800.0
    elsif params[:loan_amount] <= 1_000_000.0
      1100.0
    elsif params[:loan_amount] <= 1_500_000.0
      1500.0
    elsif params[:loan_amount] <= 2_000_000.0
      2100.0
    elsif params[:loan_amount] <= 3_000_000.0
      2800.0
    elsif params[:loan_amount] <= 4_000_000.0
      3400.0
    elsif params[:loan_amount] <= 5_000_000.0
      4100.0
    elsif params[:loan_amount] <= 6_000_000.0
      4700.0
    elsif params[:loan_amount] > 6_000_000.0
      5500.0
    end
  end

  def get_settlement_agent_fee
    if params[:loan_amount] <= 250_000.0
      400.0
    elsif params[:loan_amount] <= 1_500_000.0
      450.0
    elsif params[:loan_amount] <= 3_000_000.0
      550.0
    elsif params[:loan_amount] > 3_000_000.0
      700.0
    end
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
