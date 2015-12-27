require 'capybara'
require 'capybara/poltergeist'

module Crawler
  class LendingTreeRates < Base
    include Capybara::DSL
    attr_reader :property_type, :usage, :property_address, :state,
                :is_bankrupt, :is_foreclosed, :current_address,
                :current_zip_code, :property_zip_code, :has_second_mortgage,
                :first_mortgage_payment, :second_mortgage_payment

    def initialize(args)
      @purpose = args[:purpose]
      @property_type = args[:property_type]
      @usage = args[:usage]
      @property_address = args[:property_address]
      @state = args[:state]
      @purchase_price = args[:purchase_price]
      @down_payment = args[:down_payment]
      @credit_score = args[:credit_score]
      @is_bankrupt = args[:is_bankrupt]
      @is_foreclosed = args[:is_foreclosed]
      @current_address = args[:current_address]
      @current_zip_code = args[:current_zip_code]
      @property_zip_code = args[:property_zip_code]
      @has_second_mortgage = args[:has_second_mortgage]
      @crawler = set_up_crawler
      @results = []
    end

    def call
      go_to_lending_tree
      first_common_steps.call
      while random_steps[question]
        return Rails.logger.error("Cannot get question's content") unless question
        ap random_steps[question]
        send(random_steps[question])
      end
      second_common_steps.call
      results
    end

    def question
      count = 0
      content = nil
      while crawler.all("fieldset .form-group label")[0].nil? && count < 5
        sleep(2)
        count += 1
      end
      crawler.all("fieldset .form-group label")[0].nil? ? nil : crawler.all("fieldset .form-group label")[0].text
    end

    def random_steps
      {
        "What is the remaining 1st mortgage balance?" => "select_first_mortgage_payment",
        "Do you have a second mortgage?" => "say_yes_if_you_have_second_mortgage",
        "What is the remaining balance on the 2nd mortgage?" => "select_second_mortgage_payment",
        "Would you like to borrow additional cash?" => "do_not_borrow_additional_cash",
        "Do you need a trusted pro for a major home improvement?" => "say_no_when_asked_about_trusted_pro",
        "Do you need a trusted pro to help with your upcoming move?" => "say_no_when_asked_about_trusted_pro",
        "Estimate your credit score" => "select_credit_score",
        "When were you born?" => "select_dob",
        "Have you or your spouse served in the military?" => "select_military_service",
        "Do you currently have a VA loan?" => "say_no_when_asked_about_va",
        "Have you had a bankruptcy or foreclosure in the last 7 years?" => "say_no_when_asked_about_bankruptcy",
        "What is your current street address?" => "fill_in_current_address",
        "What is your name?" => "fill_in_full_name"
      }
    end

    private

    def go_to_lending_tree
      crawler.visit("https://www.lendingtree.com/")
      crawler.find("h2", text: "Compare Mortgage Offers Free")
      purchase? ? crawler.select("Buy a home") : crawler.select("Refinance")
      crawler.click_button("Get Personalized Rates")
    end

    def select_type_of_property
      purchase? ? crawler.find("label", text: "Great! What type of property are you purchasing?")
                : crawler.find("label", text: "Great! What type of property are you refinancing?")

      types = {
        "sfh" => "Single Family Home",
        "condo" => "Condominium",
        "default" => "Multi Family Home"
      }

      crawler.find(".label-text", text: types[property_type] || type["default"]).click
    end

    def select_property_usage
      crawler.find("label", text: "How will this property be used?")
      types = {
        "primary_residence" => "Primary Home",
        "vacation_home" => "Secondary Home",
        "rental_property" => "Rental Property"
      }

      crawler.find(".label-text", text: types[usage]).click
    end

    def fill_in_property_address
      if purchase?
        crawler.find("label", text: "In what city will the property be located?")
        crawler.find("#property-geo-search").set(state)
        crawler.find("a", text: property_address).click
      else
        crawler.find("label", text: "ZIP code of the property")
        crawler.find("#property-zip-code-input").set(property_zip_code)
        crawler.find("#ig-property-zip").click
      end
      sleep(3)
      crawler.find("#next").click
    end

    def say_yes_when_asked_about_finding_new_home
      crawler.find("label", text: "Have you already found your new home?")
      crawler.find(".label-text", text: "Yes").click
    end

    def say_yes_when_asked_about_agent
      crawler.find("label", text: "Are you currently working with a real estate agent?")
      crawler.find(".label-text", text: "Yes").click
    end

    def select_estimated_purchase_price
      crawler.find("label", text: "Please estimate the value of the property")
      crawler.execute_script("$('.ui-slider').slider('value', '#{purchase_price}')")
      crawler.find("#next").click
    end

    def select_down_payment_percentage
      # Lending Tree use 1-10 to prepresent percentage
      percentage = (down_payment.to_f / purchase_price.to_f * 10)
      crawler.execute_script("$('.ui-slider').slider('value', '#{percentage}')")
      crawler.find("#next").click
    end

    def select_first_mortgage_payment
      # crawler.find("label", text: "What is the remaining 1st mortgage balance?")
      crawler.execute_script("$('.ui-slider').slider('value', '#{first_mortgage_payment}')")
      crawler.find("#next").click
    end

    def select_second_mortgage_payment
      # crawler.find("label", text: "What is the remaining balance on the 2nd mortgage?")
      crawler.execute_script("$('.ui-slider').slider('value', '#{second_mortgage_payment}')")
      crawler.find("#next").click
    end

    def say_yes_if_you_have_second_mortgage
      # crawler.find("label", text: "Do you have a second mortgage?")
      unless has_second_mortgage
        crawler.find(".label-text", text: "No").click
        return false
      else
        crawler.find(".label-text", text: "Yes").click
      end
      true
    end

    def say_no_when_asked_about_trusted_pro
      purchase? ? crawler.find("label", text: "Do you need a trusted pro to help with your upcoming move?")
                : crawler.find("label", text: "Do you need a trusted pro for a major home improvement?")
      crawler.find(".label-text", text: "No").click
    end

    def select_credit_score
      # crawler.find("label", text: "Estimate your credit score")
      return crawler.find("span", text: "≥720").click if credit_score >= 720
      return crawler.find("span", text: "680-719").click if credit_score > 679
      return crawler.find("span", text: "640-679").click if credit_score > 639
      crawler.find("span", text: "≤639").click
    end

    def select_dob
      # crawler.find("label", text: "When were you born?")
      crawler.select("March", from: "birth-month")
      crawler.select("03", from: "birth-day")
      crawler.select("1991", from: "birth-year")
    end

    def select_military_service
      # crawler.find("label", text: "Have you or your spouse served in the military?")
      crawler.find(".label-text", text: "No").click
    end

    def say_no_when_asked_about_bankruptcy
      # crawler.find("label", text: "Have you had a bankruptcy or foreclosure in the last 7 years?")
      crawler.find(".label-text", text: "No").click
    end

    def fill_in_current_address
      # crawler.find("label", text: "What is your current street address?")
      crawler.find("#street1").set(current_address)
      crawler.find("#ig-zip-code").click
      crawler.find("#zip-code-input").set(current_zip_code)
      sleep(3)
      crawler.find("#next").click
    end

    def fill_in_full_name
      # crawler.find("label", text: "What is your name?")
      crawler.find("#first-name").set("John")
      crawler.find("#last-name").set("Doe")
      crawler.find("#next").click
    end

    def create_log_in
      crawler.find("span", text: "Let's create a login to save your progress.")
      crawler.find("#email").set("john_doe123@gmail.com")
      crawler.find("#password").set("12345678")
      sleep(3)
      crawler.find("#next").click
    end

    def fill_in_phone_number
      crawler.find("label", text: "Mobile or home phone number")
      crawler.find("#home-phone").set("888-246-4181")
      crawler.find("#next").click
    end

    def fill_in_social_security
      sleep(3)
      if question == "Social Security #"
        crawler.find("#social-security").set("123456789")
        crawler.find("label", text: "Do You Currently Have Accounts With Any Of The Following Banks?")
        crawler.find("a", text: "Skip this step").click
        crawler.find("#next")
      else
        crawler.find("#social-security-four").set("6789")
        crawler.find("#next")
        crawler.find("h4", text: "Searching Lender Network")
        sleep(30)
      end
    end

    def confirm_personal_information
      crawler.find("h1", text: "Oops!")
      crawler.find("#next").click
      crawler.find("label", text: "Social Security #")
      # crawler.find("label", text: "Please enter the last 4 digitsof your SSN")
      crawler.find("#next").click
    end

    def select_where_we_hear_about_lending_tree
      crawler.find("label", text: "Where did you hear about us?")
      crawler.all(".submitted-modal-page-hearaboutus .radio label .label-text")[1].click
    end

    def get_rates
      crawler.find("h1", text: "New Home Center")
      crawler.find(".message", text: "Our apologies but this is taking an unusually long time. Thank you for your patience.")
      sleep(30)
      crawler.find("h2", text: "30 Year Fixed")
      data = Nokogiri::HTML.parse(crawler.html)
      data.css(".offer-group").each do |list|
        lowest_rate = list.css(".offer").first
        results << {
          lender_name: lowest_rate.css(".lender-name").text.strip,
          product: list.css("h2").text,
          apr: lowest_rate.css(".kvp")[0].css(".v").text.gsub(/[^0-9\.]/, "").to_f / 100,
          interest_rate: lowest_rate.css(".kvp")[1].css(".v").text.gsub(/[^0-9\.]/, "").to_f / 100,
          down_payment: lowest_rate.css(".kvp")[2].css(".v").text.gsub(/[^0-9\.]/, "").to_f
        }
      end
    end

    def say_no_when_asked_about_may_2009
      # crawler.find("label", text: "Did you close on your mortgage on or before May 31, 2009?")
      crawler.find(".label-text", text: "No").click
    end

    def do_not_borrow_additional_cash
      # crawler.find("label", text: "Would you like to borrow additional cash?")
      crawler.find("#next").click
    end

    def say_no_when_asked_about_va
      crawler.find(".label-text", text: "No").click
    end

    def first_common_steps
      Proc.new do
        select_type_of_property
        select_property_usage
        fill_in_property_address
        select_estimated_purchase_price
      end
    end

    def second_common_steps
      Proc.new do
        create_log_in
        fill_in_phone_number
        fill_in_social_security
        confirm_personal_information
        select_where_we_hear_about_lending_tree
        get_rates
      end
    end
  end
end
