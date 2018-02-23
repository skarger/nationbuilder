require File.expand_path("../../app/path_provider.rb", __FILE__)

describe PathProvider do
  let(:slug) { 'test-nation' }
  let(:api_token) { 'test-token' }
  let(:path_provider) { PathProvider.new(slug: slug, api_token: api_token) }

  describe ".new" do
    it "accepts a slug and API token" do
      expect { described_class.new(slug: 'test-nation', api_token: 'abc') }
        .to_not raise_error
    end
  end

  describe "#index" do
    describe "events" do
      it "returns the expected URL" do
        expect(path_provider.index(:events)).to eq(
          "https://#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/events?" \
          "access_token=#{api_token}"
        )
      end
    end
  end

  describe "#create" do
    describe "events" do
      it "returns the expected URL" do
        expect(path_provider.create(:events)).to eq(
          "https://#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/events?" \
          "access_token=#{api_token}"
        )
      end
    end
  end

  describe "#delete" do
    describe "events" do
      it "returns the expected URL" do
        id = 99
        expect(path_provider.delete(:events, id)).to eq(
          "https://#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/events/#{id}?" \
          "access_token=#{api_token}"
        )
      end
    end
  end

  describe "#update" do
    describe "events" do
      it "returns the expected URL" do
        id = 99
        expect(path_provider.update(:events, id)).to eq(
          "https://#{slug}.nationbuilder.com/api/v1/sites/#{slug}/pages/events/#{id}?" \
          "access_token=#{api_token}"
        )
      end
    end
  end
end
