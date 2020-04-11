# Planning Poker

Create a room, https://poker.antew.dev
The room name can be anything you want, e.g. https://poker.antew.dev/fluffy-bunnies

![App screenshot](/assets/static/images/app-screenshot.png)

This is a small application for planning poker that I made to try out [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view).

The current set of features includes:

 * Customizable point system
 * Observer mode for people who are not betting
 * Presence detection
 * Automatically revealing bets once everyone has bet

 ## Running it locally

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
