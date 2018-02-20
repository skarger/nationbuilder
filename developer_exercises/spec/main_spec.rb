require File.expand_path("../../app/main.rb", __FILE__)

describe "main" do
  let(:logger) { Logger.new(File.expand_path("../../app/log/test.log", __FILE__)) }

  it "returns a successful exit code" do
    expect(main(logger: logger)).to eq(0)
  end

  it "creates an application logger by default" do
    allow(logger).to receive(:info)
    allow(Logger).to receive(:new).with($stderr).and_return(logger)

    main

    expect(logger).to have_received(:info).with("NationBuilder Developer Exercises: Starting")
  end
end
