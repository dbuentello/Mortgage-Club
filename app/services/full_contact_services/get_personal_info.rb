module FullContactServices
  class GetPersonalInfo
    attr_accessor :personal_info, :response, :email

    def initialize(email)
      @email = email
      @personal_info = {
        current_job_info: {
          title: nil,
          years: nil,
          company_name: nil
        },
        prev_job_info: {
          title: nil,
          years: nil,
          company_name: nil
        }
      }
      @response = []
    end

    def call
      url = "https://api.fullcontact.com/v2/person.json?apiKey=#{ENV['FULL_CONTACT_KEY']}&email=#{email}"
      connection = Faraday.new(url: url)
      @response = connection.get

      read_personal_info(JSON.parse(response.body)) if success?

      personal_info
    end

    def success?
      response.status == 200
    end

    def read_personal_info(response_data)
      return unless response_data["likelihood"].present? && response_data["likelihood"] > 0.8

      read_positions_info(response_data["organizations"]) if response_data["organizations"].present?
    end

    def read_positions_info(positions)
      # more info: https://gist.github.com/tangnv/4e31e1d69ded57124263
      positions.sort! do |position_a, position_b|
        if position_a["startDate"]
          position_a["startDate"] ? position_b["startDate"] <=> position_a["startDate"] : -1
        else
          position_b["startDate"] ? 1 : 0
        end
      end

      current_position = positions[0]
      return if current_position["current"] == false

      current_work_years = get_work_years(current_position["startDate"], "#{Time.zone.now.year}-#{Time.zone.now.month}")

      @personal_info[:current_job_info][:title] = current_position["title"]
      @personal_info[:current_job_info][:years] = current_work_years
      @personal_info[:current_job_info][:company_name] = current_position["name"]

      if current_work_years < 2 && positions[1].present?
        prev_position = positions[1]

        @personal_info[:prev_job_info][:title] = prev_position["title"]
        @personal_info[:prev_job_info][:years] = get_work_years(prev_position["startDate"], prev_position["endDate"])
        @personal_info[:prev_job_info][:company_name] = prev_position["name"]
      end
    end

    def get_work_years(start_date, end_date)
      # format_date: "2016-03"

      return 0 if start_date.nil? || end_date.nil?

      additional_year = 0
      month_end_date = end_date[5..6].to_i
      month_start_date = start_date[5..6].to_i

      additional_year = 1 if month_end_date - month_start_date > 0

      end_date[0..3].to_i - start_date[0..3].to_i + additional_year
    end
  end
end
