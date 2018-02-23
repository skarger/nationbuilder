require "logger"
require "json"


app_directory = File.dirname(File.expand_path(__FILE__))
Dir.chdir(app_directory)
Dir.glob("*rb") do |file|
  unless file == "main.rb"
    require_relative file
  end
end

def main(logger: Logger.new($stderr))
  logger.info("NationBuilder Developer Exercises: Starting")

  if ENV['NB_API_TOKEN'].to_s.empty?
    logger.warn("ENV['NB_API_TOKEN'] unset. Exiting.")
    1
  elsif ENV['NB_SLUG'].to_s.empty?
    logger.warn("ENV['NB_SLUG'] unset. Exiting.")
    1
  else
    path_provider = PathProvider.new(slug: ENV['NB_SLUG'], api_token: ENV['NB_API_TOKEN'])
    if run_live_program?
      logger.info("Fetching existing events")
      response = get_events(path_provider)
      if response.status != 200
        report_failed_request_and_exit(logger)
      end

      logger.info("Deleting existing events")
      event_ids_names(response).each do |id, name|
        logger.info("Deleting event #{id}: #{name}")
        response = delete_event(path_provider, id)
        if response.status != 204
          report_failed_request_and_exit(logger)
        end
      end

      logger.info("Creating event")
      response = create_event(path_provider)
      if response.status != 200
        report_failed_request_and_exit(logger)
      else
        event_id, event_name = event_id_name(JSON.parse(response.body)["event"])
        logger.info("Created event #{event_id}: #{event_name}")
      end
    end

    0
  end
ensure
  logger.info("NationBuilder Developer Exercises: Finished")
end

def run_live_program?
  $PROGRAM_NAME == __FILE__
end

def report_failed_request_and_exit(logger)
  logger.warn("Request failed: #{response.status}")
  logger.warn(response.body)
  exit 2
end

def get_events(path_provider)
  Client.index(path_provider: path_provider, resource: :events)
end

def delete_event(path_provider, id)
  Client.delete(path_provider: path_provider, resource: :events, id: id)
end

def create_event(path_provider)
  Client.create(path_provider: path_provider, resource: :events, payload: event)
end

def event_ids_names(response)
  data = JSON.parse(response.body)
  data["results"].map { |event| event_id_name(event) }
end

def event_id_name(event)
  [event["id"], event["name"]]
end

def event
  JSON.parse <<~EVENT_JSON
  {
    "event": {
      "status": "unlisted",
      "name": "BBQ",
      "intro": "Let's Grill",
      "time_zone": "Eastern Time (US & Canada)",
      "start_time": "2018-06-01T12:00:00-00:00",
      "end_time": "2013-05-08T19:00:00-00:00",
      "contact": {
        "name": "Stephen",
        "contact_phone": "1234567890",
        "show_phone": true,
        "contact_email": "stephen@test.com",
        "email": "stephen@test.com",
        "show_email": true
      },
      "rsvp_form": {
        "phone": "optional",
        "address": "optional",
        "allow_guests": true,
        "accept_rsvps": true,
        "gather_volunteers": true
      },
      "show_guests": true,
      "capacity": 80,
      "venue": {
        "name": "Stephen's Backyard",
        "address": {
          "address1": "123 Foo St",
          "city": "Cambridge",
          "state": "MA"
        }
      }
    }
  }
  EVENT_JSON
end

if run_live_program?
  main
end
