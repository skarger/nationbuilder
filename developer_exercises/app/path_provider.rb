class PathProvider
  def initialize(slug:, api_token:)
    @slug = slug
    @api_token = api_token
  end

  attr_reader :slug, :api_token

  def index(resource)
    "#{base_url}/sites/#{slug}/pages/#{resource}?#{access_token}"
  end

  def create(resource)
    if resource == :events
      "#{base_url}/sites/#{slug}/pages/#{resource}?#{access_token}"
    else
      "#{base_url}/#{resource}?#{access_token}"
    end
  end

  def delete(resource, id)
    if resource == :events
      "#{base_url}/sites/#{slug}/pages/#{resource}/#{id}?#{access_token}"
    else
      "#{base_url}/#{resource}/#{id}?#{access_token}"
    end
  end

  def update(resource, id)
    if resource == :events
    "#{base_url}/sites/#{slug}/pages/#{resource}/#{id}?#{access_token}"
    else
      "#{base_url}/#{resource}/#{id}?#{access_token}"
    end
  end

  private

  def base_url
    "https://#{slug}.nationbuilder.com/api/v1"
  end

  def access_token
    "access_token=#{api_token}"
  end
end
