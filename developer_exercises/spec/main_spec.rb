require File.expand_path("../../app/main.rb", __FILE__)

describe "main" do
  let(:logger) { Logger.new(File.expand_path("../../app/log/test.log", __FILE__)) }

  it "returns a successful exit code" do
    ENV['NB_API_TOKEN'] = 'abc'
    ENV['NB_SLUG'] = 'mynation'
    expect(main(logger: logger)).to eq(0)
  end

  it "creates an application logger by default" do
    ENV['NB_API_TOKEN'] = 'abc'
    allow(logger).to receive(:info)
    allow(Logger).to receive(:new).with($stderr).and_return(logger)

    main

    expect(logger).to have_received(:info).with("NationBuilder Developer Exercises: Starting")
  end

  it "errors out if no API token set" do
    ENV['NB_API_TOKEN'] = nil
    ENV['NB_SLUG'] = 'mynation'
    allow(logger).to receive(:warn)
    allow(Logger).to receive(:new).with($stderr).and_return(logger)

    expect(main(logger: logger)).to eq(1)

    expect(logger).to have_received(:warn).with("ENV['NB_API_TOKEN'] unset. Exiting.")
  end

  it "errors out if no nation slug set" do
    ENV['NB_API_TOKEN'] = 'abc'
    ENV['NB_SLUG'] = nil
    allow(logger).to receive(:warn)
    allow(Logger).to receive(:new).with($stderr).and_return(logger)

    expect(main(logger: logger)).to eq(1)

    expect(logger).to have_received(:warn).with("ENV['NB_SLUG'] unset. Exiting.")
  end
end
