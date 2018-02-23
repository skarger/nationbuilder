require "roda"

class App < Roda
  route do |r|
    # GET / request
    r.root do
      r.redirect "/event"
    end

    r.on "event" do

      r.is do
        # GET /hello request
        r.get do
          "Hello!"
        end

        # PUT /event request
        r.put do
          puts "Someone said ABC!"
          r.redirect
        end
      end
    end
  end
end
