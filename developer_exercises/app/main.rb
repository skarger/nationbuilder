require "logger"
require "json"

require_relative "./helpers.rb"
Helpers.require_files

CONFIGURATION_ERROR = 1
REQUEST_FAILED = 2

def main(logger: Logger.new($stderr))
  logger.info("NationBuilder Developer Exercises: Starting")

  report_configuration_error_and_exit(logger) if environment_invalid?

  if run_live_program?
    path_provider = PathProvider.new(slug: ENV['NB_SLUG'],
                                     api_token: ENV['NB_API_TOKEN'])

    logger.info("Fetching existing events")
    response = Client.index(path_provider: path_provider, resource: :events)
    report_failed_request_and_exit(logger) unless response.status == 200

    logger.info("Deleting existing events")
    event_ids_names(response).each do |id, name|
      logger.info("Deleting event #{id}: #{name}")
      response = Client.delete(path_provider: path_provider,
                               resource: :events,
                               id: id)
      report_failed_request_and_exit(logger) unless response.status == 204
    end

    logger.info("Creating event")
    response = Client.create(path_provider: path_provider,
                             resource: :events,
                             payload: Event.new.payload)
    report_failed_request_and_exit(logger) unless response.status == 200

    event_id, event_name = event_id_name(JSON.parse(response.body)["event"])
    logger.info("Created event #{event_id}: #{event_name}")
  end

  0
ensure
  logger.info("NationBuilder Developer Exercises: Finished")
end

def run_live_program?
  $PROGRAM_NAME == __FILE__
end

def report_failed_request_and_exit(logger)
  logger.warn("Request failed: #{response.status}")
  logger.warn(response.body)
  exit REQUEST_FAILED
end

def environment_invalid?
  ENV['NB_API_TOKEN'].to_s.empty? || ENV['NB_SLUG'].to_s.empty?
end

def report_configuration_error_and_exit(logger)
  if ENV['NB_API_TOKEN'].to_s.empty?
    logger.warn("ENV['NB_API_TOKEN'] unset. Exiting.")
  elsif ENV['NB_SLUG'].to_s.empty?
    logger.warn("ENV['NB_SLUG'] unset. Exiting.")
  end
  exit CONFIGURATION_ERROR
end

def event_ids_names(response)
  data = JSON.parse(response.body)
  data["results"].map { |event| event_id_name(event) }
end

def event_id_name(event)
  [event["id"], event["name"]]
end

if run_live_program?
  main
end
