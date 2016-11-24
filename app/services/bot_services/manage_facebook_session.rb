# rubocop:disable ClassVars
module BotServices
  class ManageFacebookSession
    @@session_ids = {}

    def self.set_session(key, value)
      @@session_ids[key.to_sym] = value
    end

    def self.get_session(key)
      @@session_ids[key.to_sym]
    end

    def self.get_all
      @@session_ids
    end

    def self.reset_all
      @@session_ids = {}
    end
  end
end
# rubocop:enable ClassVars
