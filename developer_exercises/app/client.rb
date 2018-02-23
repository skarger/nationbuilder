require 'faraday'

module Client
  module_function

  def create(path_provider:, resource:)
    Faraday.post path_provider.create(resource)
  end
end
