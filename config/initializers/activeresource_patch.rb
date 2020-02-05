Rails.application.configure do

  def activeresource_logger
    @activeresource_logger ||= Logger.new("#{Rails.root}/log/activeresource_logger.log")
  end

  ActiveSupport::Notifications.subscribe('request.active_resource')  do |name, start, finish, id, payload|
    if Rails.env.development?
      activeresource_logger.info("====================== #{start} : #{payload[:method].upcase} ======================")
      activeresource_logger.info("payload: #{payload[:request_uri]}")
      #activeresource_logger.info("PATH: #{payload[:request_path]}")
      #activeresource_logger.info("BODY: #{payload[:request_body]}")
      #activeresource_logger.info("HEADERS: #{payload[:request_headers]}")
      # activeresource_logger.info("STATUS_CODE: #{payload[:result].code}")
      # activeresource_logger.info("RESPONSE_BODY: #{payload[:result].body}")
    end
  end
end