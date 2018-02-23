class PathProvider
  def initialize(slug:, api_token:)
    @slug = slug
    @api_token = api_token
  end

  attr_reader :slug, :api_token

  def index(resource)
    "#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/#{resource}?" \
    "access_token=#{api_token}"
  end

  def create(resource)
    "#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/#{resource}?" \
    "access_token=#{api_token}"
  end
end
