require 'faraday'

module Client

  module_function
  def index(path_provider:, resource:)
    conn = Faraday.new(url: path_provider.index(resource))
    conn.get do |req|
      req.headers['Accept'] = 'application/json'
    end
  end

  module_function
  def create(path_provider:, resource:, payload: {})
    conn = Faraday.new(url: path_provider.create(resource))
    conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate(payload)
    end
  end

  module_function
  def delete(path_provider:, resource:, id:)
    conn = Faraday.new(url: path_provider.delete(resource, id))
    conn.delete do |req|
      req.headers['Accept'] = 'application/json'
    end
  end
end
