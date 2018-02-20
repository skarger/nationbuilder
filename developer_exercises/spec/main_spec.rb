require File.expand_path("../../app/main.rb", __FILE__)

describe "main" do
  it "returns a successful exit code" do
    expect(main).to eq(0)
  end
end
