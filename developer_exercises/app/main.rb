require "logger"


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
      create_event
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
  {
  }
end

if run_live_program?
  main
end
