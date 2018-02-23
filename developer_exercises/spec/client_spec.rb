require File.expand_path("../../app/client.rb", __FILE__)

describe Client do
  let(:create_path) { "https://www.example.com/test_create" }
  let(:resource) { :test_resource }
  let(:path_provider) do
    klass = Class.new do
      def initialize(path)
        @path = path
      end

      def create(resource)
        @path
      end
    end

    klass.new(create_path)
  end

  describe ".create" do
    it "takes a path provider and a resource" do
      stub_request(:post, create_path)

      client = Client.create(path_provider: path_provider, resource: resource)

      expect(a_request(:post, create_path)).to have_been_made.once
    end

    it "defaults payload to {}" do
      stub_request(:post, create_path)

      client = Client.create(path_provider: path_provider, resource: resource)

      expect(a_request(:post, create_path).with(body: {})).to have_been_made.once
    end

    it "accepts a payload" do
      stub_request(:post, create_path)

      expected_payload = {
        "key" => "value"
      }
      client = Client.create(path_provider: path_provider,
                             resource: resource,
                             payload: expected_payload)

      expect(a_request(:post, create_path).with(body: expected_payload))
        .to have_been_made.once
    end
  end
end
