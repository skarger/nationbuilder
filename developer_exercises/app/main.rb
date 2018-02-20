require "logger"

def main(logger: Logger.new($stderr))
  logger.info("NationBuilder Developer Exercises: Starting")

  0
end


if $PROGRAM_NAME == __FILE__
  main
end
