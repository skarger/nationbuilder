require "roda"
require "json"

require_relative "./helpers.rb"
include Helpers
require_files

class App < Roda
  include NBConfiguration
  plugin :render, views: "views"

  def event(event_index_response)
    data = JSON.parse(event_index_response.body)
    data["results"].first
  end

  def logger
    env["rack.logger"]
  end

  route do |r|
    # NationBuilder API URL provider
    @path_provider = PathProvider.new(slug: nb_slug,
                                      api_token: nb_api_token)
    r.on proc{ true } do
      if !nb_configuration_valid?
        response.status = 500
        message = "Configuration missing: NB_API_TOKEN and NB_SLUG must be set in ENV."
        logger.info(message)
        message
      else
        # GET / request
        r.root do
          r.redirect "/event"
        end

        r.on "event" do
          r.is do
            r.get do
              # fetch events, show the first one
              response = Client.index(path_provider: @path_provider, resource: :events)
              event = event(response)

              render("event", locals: {
                id: event["id"],
                name: event["name"],
                intro: event["intro"],
                status: event["status"],
                start_time: event["start_time"],
                end_time: event["end_time"]
              })
            end

            # POST /event request
            r.post do
              # just for this demo we're trusting the input from the client as-is
              response = Client.update(path_provider: @path_provider,
                                       resource: :events,
                                       id: r.params["event"]["id"],
                                       payload: r.params)

              r.redirect
            end
          end
        end
      end
    end
  end
end
