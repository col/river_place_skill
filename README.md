# RiverPlaceSkill

# Example Scenario's

## Example 1
Me: Alexa, ask River Place to book me a tennis court
Alexa: Ok. When would you like to play?
Me: Tonight
Alexa: What time would you like?
Me: What times are available?
Alexa: There are 3 slots available. 5pm, 7pm and 9pm
Me: Ok, book the 9pm slot please.
Alexa: OK, I've booked court 2 for you tonight at 9pm

## Example 2
Me: Alexa, tell River Place I want to play tennis tomorrow at 9am
Alexa: Both courts are booked at 9am tomorrow. How about 10am?
Me: Sure. That'll do.
Alexa: OK, I've booked court 2 for you tomorrow at 10am

# Utterances

I'm using flutterance here so you need to run this command to generate the utterance.txt file.
``flutterance config/flutterances.txt utterances.txt``


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add river_place_skill to your list of dependencies in `mix.exs`:

        def deps do
          [{:river_place_skill, "~> 0.0.1"}]
        end

  2. Ensure river_place_skill is started before your application:

        def application do
          [applications: [:river_place_skill]]
        end
