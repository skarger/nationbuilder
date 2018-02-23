# nationbuilder

NationBuilder related code.

## Developer Excercises

To become a NationBuilder certified developer you must complete a sample of their [developer exercises](http://nationbuilder.com/developer_exercises).

I do this in the developer_excercises directory.

### Running the developer exercises code

#### Prerequisites

You must have a Nation with Developer features enabled and a test API token.

#### Setup

From the developer_exercises directory install gems:

```
cd developer_exercises

bundle install
```

First there is a non-interactive script, `app/main.rb`, that makes requests to the NationBuilder API.

The program expects to find `ENV["NB_API_TOKEN"]` and `ENV["NB_SLUG"]` in order to authenticate. You can add them to the environment on startup:

```
NB_API_TOKEN=<token> NB_SLUG=<slug> ruby developer_exercises/app/main.rb
```

Then there is a web app used to connect user input to the API. You can view it locally at [http://localhost:3000](http://localhost:3000) after starting it up as described below.

To run the web app without code reloading:

```
rackup app/config.ru --port 3000
```

To run it with code reloading:

```
bundle exec rerun -- rackup app/config.ru --port 3000
```

This uses the [Rerun](https://github.com/alexch/rerun) gem to automatically restart the app when files change.

### Development

For the developer exercises, to run the tests:

```
cd developer_exercises

rspec
```
