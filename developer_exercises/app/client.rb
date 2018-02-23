require 'faraday'
require 'pry'

module Client
  module_function

  def create(path_provider:, resource:, payload: {})
    conn = Faraday.new(url: path_provider.create(resource))
    conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate(payload)
    end
  end
end
