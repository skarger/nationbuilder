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

The program expects to find `ENV["NB_API_TOKEN"]` in order to authenticate. You can add it to the environment on startup:

```
NB_API_TOKEN=<token> ruby developer_exercises/app/main.rb
```
