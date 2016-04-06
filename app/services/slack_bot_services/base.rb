module SlackBotServices
  class Base
    attr_reader :service, :params

    def initialize(params)
      @params = params
      @service = select_service
    end

    def call
      return unless service

      service.call(params)
    end

    def select_service
      case conversation
      when "get-quotes"
        return SlackBotServices::GetInfoOfQuotes
      when "create-account"
        return SlackBotServices::NotifySignUp
      when "create-rate-alert"
        return SlackBotServices::NotifyRateAlert
      end
    end

    private

    def conversation
      return unless params["result"].present? && params["result"]["parameters"].present?

      params["result"]["parameters"]["conversation"]
    end
  end
end
