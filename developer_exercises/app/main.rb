require "logger"
require "json"


directory = File.dirname(File.expand_path(__FILE__))
Dir.chdir(directory)
Dir.glob("*rb") do |f|
  unless f == "main.rb"
    require_relative f
  end
end

def run_live_program?
  $PROGRAM_NAME == __FILE__
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
    if run_live_program?
      logger.info("Creating Event")
      response = create_event
    end

    0
  end
ensure
  logger.info("NationBuilder Developer Exercises: Finished")
end

def create_event
  path_provider = PathProvider.new(slug: ENV['NB_SLUG'], api_token: ENV['NB_API_TOKEN'])
  Client.create(path_provider: path_provider, resource: :events, payload: event)
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
