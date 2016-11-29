module BotServices
  class FacebookService
    include HTTParty
    base_uri "https://graph.facebook.com/v2.6"

    FB_PAGE_ACCESS_TOKEN = ENV["FB_PAGE_ACCESS_TOKEN"]
    FB_PAGE_ID = ENV["FB_PAGE_ID"]

    def self.text_message(message)
      {
        text: message
      }
    end

    def self.quick_replies_message(text, quick_replies)
      {
        text: text,
        quick_replies: quick_replies
      }
    end

    def self.file_message(file_url)
      {
        attachment: {
          type: "file",
          payload: {
            url: file_url
          }
        }
      }
    end

    def self.image_message(image_url)
      {
        attachment: {
          type: "image",
          payload: {
            url: image_url
          }
        }
      }
    end

    def self.button_message(text, buttons)
      {
        attachment: {
          type: "template",
          payload: {
            template_type: "button",
            text: text,
            buttons: buttons
          }
        }
      }
    end

    def self.generic_message(messages)
      messages_data = {
        attachment: {
          type: "template",
          payload: {
            template_type: "generic",
            elements: []
          }
        }
      }

      messages.each_with_index do |message, _index|
        message_data = {
          title: message[:title],
          image_url: message[:img_url],
          subtitle: message[:subtitle],
          buttons: [{
            type: "web_url",
            url: message[:url],
            title: "Get this rate"
          }]
        }
        messages_data[:attachment][:payload][:elements] << message_data
      end

      messages_data
    end

    def self.send_message(sender_id, message_data)
      body = {
        recipient: {
          id: sender_id
        },
        message: message_data
      }

      ap post "/me/messages", body: JSON.dump(body), format: :json
    end

    def self.config_welcome_screen
      body = {
        "setting_type": "greeting",
        "greeting": {
          "text": "Hi, welcome to this bot."
        }
      }

      post "/#{FB_PAGE_ID}/thread_settings", body: JSON.dump(body), format: :json
    end

    def self.get_user_profile(fb_user_id)
      response = get("/#{fb_user_id}?fields=first_name,last_name,profile_pic")
      response.body
    end

    def self.subscribe_request
      post("/me/subscribed_apps")
    end

    # Default HTTParty options.
    def self.default_options
      super.merge(
        query: {
          access_token: FB_PAGE_ACCESS_TOKEN
        },
        headers: {
          'Content-Type' => 'application/json'
        }
      )
    end
  end
end
