require "logger"

def main(logger: Logger.new($stderr))
  logger.info("NationBuilder Developer Exercises: Starting")

  if ENV['NB_API_TOKEN'].nil? || ENV['NB_API_TOKEN'].empty?
    logger.warn("ENV['NB_API_TOKEN'] unset. Exiting.")
    1
  else
    0
  end
ensure
  logger.info("NationBuilder Developer Exercises: Finished")
end


if $PROGRAM_NAME == __FILE__
  main
end
