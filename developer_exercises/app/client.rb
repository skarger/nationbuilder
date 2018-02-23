require 'faraday'

module Client
  module_function

  def create(path_provider:, resource:, payload: {})
    Faraday.post path_provider.create(resource), payload
  end
end
