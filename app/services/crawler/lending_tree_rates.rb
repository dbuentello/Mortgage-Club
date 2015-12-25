require 'capybara'
require 'capybara/poltergeist'

module Crawler
  class LendingTreeRates < Base
    include Capybara::DSL
    attr_reader :property_type, :usage, :property_address, :state,
                :is_bankrupt, :is_foreclosed, :current_address,
                :zip_code

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
      @zip_code = args[:zip_code]

      @crawler = set_up_crawler
      @results = []
    end

    def call
      go_to_lending_tree
      select_purpose_of_mortgage
      select_type_of_property
      select_property_usage
      fill_in_property_address
      say_yes_when_asked_about_finding_new_home
      say_yes_when_asked_about_agent
      select_estimated_purchase_price
      say_no_when_asked_about_trusted_pro
      select_credit_score
      select_dob
      select_military_service
      say_no_when_asked_about_bankruptcy
      fill_in_current_address
      fill_in_full_name
      create_log_in
      fill_in_phone_number
      fill_in_social_security
      confirm_personal_information
      select_where_we_hear_about_lending_tree
      get_rates
    end

    private

    def go_to_lending_tree
      crawler.visit("https://www.lendingtree.com/")
      crawler.find("h2", text: "Compare Mortgage Offers Free")
    end

    def select_purpose_of_mortgage
      purchase? ? select_purchase : select_refinance
      crawler.click_button("Get Personalized Rates")
    end

    def select_type_of_property
      crawler.find("label", text: "Great! What type of property are you purchasing?")
      types = {
        "sfh" => "Single Family Home",
        "condo" => "Condominium"
      }

      crawler.find(".label-text", text: types[property_type]).click
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
      crawler.find("label", text: "In what city will the property be located?")
      crawler.find("#property-geo-search").set(state)
      crawler.find("a", text: property_address).click
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
      crawler.execute_script("$('.ui-slider').slider('value', '#{purchase_price}')")
      crawler.find("#next").click
    end

    def select_estimated_purchase_price
      crawler.execute_script("$('.ui-slider').slider('value', '#{purchase_price}')")
      crawler.find("#next").click
    end

    def say_no_when_asked_about_trusted_pro
      crawler.find("label", text: "Do you need a trusted pro to help with your upcoming move?")
      crawler.find(".label-text", text: "No").click
    end

    def select_credit_score
      crawler.find("label", text: "Estimate your credit score")
      return crawler.find("#stated-credit-history-excellent").click if credit_score >= 720
      return crawler.find("#stated-credit-history-good").click if credit_score > 679
      return crawler.find("#stated-credit-history-fair").click if credit_score > 639
      crawler.find("#stated-credit-history-poor").click
    end

    def select_dob
      crawler.find("label", text: "When were you born?")
      crawler.select("March", from: "birth-month")
      crawler.select("03", from: "birth-day")
      crawler.select("1991", from: "birth-year")
      crawler.find("#next").click
    end

    def select_military_service
      crawler.find("label", text: "Have you or your spouse served in the military?")
      crawler.find(".label-text", text: "No").click
    end

    def say_no_when_asked_about_bankruptcy
      crawler.find("label", text: "Have you had a bankruptcy or foreclosure in the last 7 years?")
      crawler.find(".label-text", text: "No").click
    end

    def fill_in_current_address
      crawler.find("label", text: "What is your current street address?")
      crawler.find("#street1").set(current_address)
      crawler.find("#zip-code-input").set(zip_code)
      crawler.find("#next").click
    end

    def fill_in_full_name
      crawler.find("label", text: "What is your name?")
      crawler.find("#first-name").set("John")
      crawler.find("#last-name").set("Doe")
      crawler.find("#next").click
    end

    def create_log_in
      crawler.find("label", text: "Let's create a login to save your progress.")
      crawler.find("#email").set("john_doe123@gmail.com")
      crawler.find("#password").set("12345678")
      crawler.find("#next").click
    end

    def fill_in_phone_number
      crawler.find("label", text: "Mobile or home phone number")
      crawler.find("#home-phone").set("888-246-4181")
      crawler.find("#next").click
    end

    def fill_in_social_security
      crawler.find("label", text: "Social Security #")
      crawler.find("#social-security").set("123456789")
      crawler.find("#next").click

      crawler.find("label", text: "Do You Currently Have Accounts With Any Of The Following Banks?")
      crawler.find("a", text: "Skip this step").click
    end

    def confirm_personal_information
      crawler.find("h3", text: "Your personal information doesn't seem to match up.")
      crawler.find("#next").click
      crawler.find("label", text: "Social Security #")
      crawler.find("#next").click
    end

    def select_where_we_hear_about_lending_tree
      crawler.find("label", text: "Where did you hear about us?")
      crawler.all(".submitted-modal-page-hearaboutus .radio label .label-text")[0].click
    end

    def get_rates
      crawler.find("h1", text: "New Home Center")
    end

    def select_purchase
      crawler.select("Buy a home")
    end

    def select_refinance
      crawler.select("Refinance")
    end
  end
end