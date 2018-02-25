require "logger"
require "json"

require_relative "./helpers.rb"
include Helpers
require_files

include NBConfiguration

SUCCESS = 0
CONFIGURATION_ERROR = 1
REQUEST_FAILED = 2

def main(logger: Logger.new($stderr))
  logger.info("NationBuilder Developer Exercises: Starting")

  if !nb_configuration_valid?
    log_nb_configuration_error(logger)
    return CONFIGURATION_ERROR
  end

  if run_live_program?
    path_provider = PathProvider.new(slug: nb_slug,
                                     api_token: nb_api_token)

    logger.info("Fetching existing events")
    response = Client.index(path_provider: path_provider, resource: :events)
    unless response.status == 200
      log_failed_request(logger)
      return REQUEST_FAILED
    end

    logger.info("Deleting existing events")
    event_ids_names(response).each do |id, name|
      logger.info("Deleting event #{id}: #{name}")
      response = Client.delete(path_provider: path_provider,
                               resource: :events,
                               id: id)
      unless response.status == 204
        log_failed_request(logger)
        return REQUEST_FAILED
      end
    end

    logger.info("Creating event")
    response = Client.create(path_provider: path_provider,
                             resource: :events,
                             payload: Event.new.payload)
    unless response.status == 200
      log_failed_request(logger)
      return REQUEST_FAILED
    end

    event_id, event_name = event_id_name(JSON.parse(response.body)["event"])
    logger.info("Created event #{event_id}: #{event_name}")
  end

  SUCCESS
ensure
  logger.info("NationBuilder Developer Exercises: Finished")
end

def run_live_program?
  $PROGRAM_NAME == __FILE__
end

def log_failed_request(logger)
  logger.warn("Request failed: #{response.status}")
  logger.warn(response.body)
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
