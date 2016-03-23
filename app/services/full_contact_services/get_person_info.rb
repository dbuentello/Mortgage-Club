module FullContactServices
  class GetPersonInfo
    attr_reader :email
    attr_accessor :person_info, :response

    def initialize(email)
      @email = email
      @person_info = {
        crr_work_info: {
          title: "",
          years: "",
          name: ""
        },
        prev_work_info: {
          title: "",
          years: "",
          name: ""
        }
      }
      @response = []
    end

    def call
      url = "https://api.fullcontact.com/v2/person.json?apiKey=#{ENV['FULL_CONTACT_KEY']}&email=#{email}"
      connection = Faraday.new(url: url)
      @response = connection.get

      read_person_info(JSON.parse(response.body)) if success?

      person_info
    end

    def success?
      response.status == 200
    end

    def read_person_info(response_data)
      read_positions_info(response_data["organizations"]) if response_data["organizations"].present?
    end

    def read_positions_info(positions)
      crr_position = positions[0]
      return if crr_position["current"] == false

      crr_work_years = get_work_years(crr_position["startDate"], "#{Time.zone.now.year}-#{Time.zone.now.month}")

      @person_info[:crr_work_info][:title] = crr_position["title"].to_s
      @person_info[:crr_work_info][:years] = crr_work_years
      @person_info[:crr_work_info][:name] = crr_position["name"].to_s

      if crr_work_years < 2 && positions[1].present?
        prev_position = positions[1]

        @prev_work_info[:work_info][:title] = prev_position["title"].to_s
        @prev_work_info[:work_info][:years] = get_work_years(prev_position["startDate"], prev_position["endDate"])
        @prev_work_info[:work_info][:name] = prev_position["name"].to_s
      end
    end

    def get_work_years(start_date, end_date)
      additional_year = 0
      month_end_date = end_date[5..6].to_i
      month_start_date = start_date[5..6].to_i

      additional_year = 1 if month_end_date - month_start_date > 0

      end_date[0..3].to_i - start_date[0..3].to_i + additional_year
    end
  end
end
