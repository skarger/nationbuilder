module Helpers
  module_function
  def require_files
    app_directory = File.dirname(File.expand_path(__FILE__))
    Dir.chdir(app_directory)
    Dir.glob("*rb") do |file|
      unless file == "main.rb"
        require_relative file
      end
    end
  end
end
