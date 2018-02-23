require "roda"
require "json"

require_relative "./helpers.rb"
Helpers.require_files

class App < Roda
  plugin :render, views: "views"

  def event(response)
    data = JSON.parse(response.body)
    data["results"].first
  end

  def event_id_name(event)
    [event["id"], event["name"]]
  end

  route do |r|
    # NationBuilder API URL provider
    @path_provider = PathProvider.new(slug: ENV['NB_SLUG'],
                                      api_token: ENV['NB_API_TOKEN'])
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
          params = r.params
          puts params
          # just for this demo we're trusting the input from the client as-is
          event_id = params["event"]["id"]
          response = Client.update(path_provider: @path_provider,
                                   resource: :events,
                                   id: event_id,
                                   payload: params)

          r.redirect
        end
      end
    end
  end
end
