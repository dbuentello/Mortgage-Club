class AbbyyOcr
  include HTTParty
  require "rexml/document"

  # IMPORTANT!
  # Make sure you have rest-client (see https://github.com/archiloque/rest-client for detaile) gem installed or install it:
  #    gem install rest-client
  require "rest_client"

  # Routine for OCR SDK error output
  def self.output_response_error(response)
    # Parse response xml (see http://ocrsdk.com/documentation/specifications/status-codes)
    xml_data = REXML::Document.new(response)
    error_message = xml_data.elements["error/message"]
    Rails.logger.error "Error: #{error_message.text}" if error_message
  end

  def self.get_recognized_text
    # CGI.escape is needed to escape whitespaces, slashes and other symbols
    # that could invalidate the URI if any
    # Name of application you created
    application_id = CGI.escape(ENV['ABBYY_CLOUD_APP_NAME'])
    password = CGI.escape(ENV['ABBYY_CLOUD_APP_KEY'])

    file_name = "#{Rails.root}/vendor/files/Sample paycheck.pdf"

    language = "English"

    # OCR SDK base url with application id and password
    base_url = "http://#{application_id}:#{password}@cloud.ocrsdk.com"

    # Upload and process the image (see http://ocrsdk.com/documentation/apireference/processImage)
    Rails.logger.info "File will be recognized with #{language} language."
    Rails.logger.info "Uploading file.."
    begin
      response = RestClient.post("#{base_url}/processImage?language=#{language}&exportFormat=txt", upload: {
        file: File.new(file_name, 'rb')
      })
    rescue RestClient::ExceptionWithResponse => e
      # Show processImage errors
      output_response_error(e.response)
      raise
    else
      # Get task id from response xml to check task status later
      xml_data = REXML::Document.new(response)
      task_element = xml_data.elements["response/task"]
      task_id = task_element.attributes["id"]
      # Obtain the task status here so that the loop below is not started
      # if your application account has not enough credits
      task_status = task_element.attributes["status"]
    end

    # Get task information in a loop until task processing finishes
    Rails.logger.info "Waiting till file is processed.."
    while task_status == "InProgress" or task_status == "Queued"
      begin
        # Note: it's recommended that your application waits
        # at least 2 seconds before making the first getTaskStatus request
        # and also between such requests for the same task.
        # Making requests more often will not improve your application performance.
        # Note: if your application queues several files and waits for them
        # it's recommended that you use listFinishedTasks instead (which is described
        # at http://ocrsdk.com/documentation/apireference/listFinishedTasks/).
        # Wait a bit
        sleep(5)

        # Call the getTaskStatus function (see http://ocrsdk.com/documentation/apireference/getTaskStatus)
        response = RestClient.get("#{base_url}/getTaskStatus?taskid=#{task_id}")
      rescue RestClient::ExceptionWithResponse => e
        # Show getTaskStatus errors
        output_response_error(e.response)
        raise
      else
        # Get the task status from response xml
        xml_data = REXML::Document.new(response)
        task_element = xml_data.elements["response/task"]
        task_status = task_element.attributes["status"]
      end
    end

    # Check if there were errors ..
    raise "The task hasn't been processed because an error occurred" if task_status == "ProcessingFailed"

    # .. or you don't have enough credits (see http://ocrsdk.com/documentation/specifications/task-statuses for other statuses)
    raise "You don't have enough money on your account to process the task" if task_status == "NotEnoughCredits"

    # Get the result download link
    download_url = xml_data.elements["response/task"].attributes["resultUrl"]

    # Download the result
    Rails.logger.info "Downloading result.. from #{download_url}"
    recognized_text = RestClient.get(download_url)

    # We have the recognized text - output it!
    ap recognized_text
  end

end
