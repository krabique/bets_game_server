![make a bet!](https://raw.githubusercontent.com/krabique/bets_game_server/master/bet-now.jpg "make a bet!")

# Game Server

Satisfy your playa' passion with a bit of betting. Come and loose all of your... I mean, Come and win a fortune at our uber-duper-hydro-nano-mega Betting App! You lucky dog!

## Live preview

Live preview is available at https://polar-dawn-15904.herokuapp.com/ (you won't need to approve your email, and there will be no message sent)

## Features

- no page reloading (auto-updates for accounts, top chart and last bets)
- loading ECB currency exchange rates every hour
- maximum bet (1/2 of the service's profit for past 24 hours + minimal bet of 1 EUR, or just 1 EUR if there is no profit
- top winners chart in EUR (with any currency being exchanged into EUR for the chart)
- bets history (showing last 5 bets)
- etc


## TO DO

- feature specs for JS (I was unsuccessful at configuring any available modern driver in headless mode, and poltergeist is too dated as of now and won't support ES6)
- move the bets validations logic from controller to model (rly, pls)
- somehow test the update currency exchange rates recurrent job enqueueing itself (move the callback logic to a separate file and test just that?)
- rebuild the front-end using React or smt (as Rails seem way too stateless for such an app)

## Getting Started

What you basically need to do to get the app running is:

1. Use `rvm` to define proper ruby and Rails versions, something like that
```
rvm install ruby-2.4.2
rvm gemset create game_server_rails514
rvm 2.4.2@game_server_rails514
gem install rails -v 5.1.4
```
2. Clone the repo and install the gems
```
git clone git@github.com:krabique/bets_game_server.git
cd bets_game_server
gem install bundle
bundle install
```
3. Start postgresql and setup the database (and don't look at me if you encounter any problems with postgresql...)
```
sudo service postgresql start
rails db:setup
```
4. Set the random.org API key environment variable (grab one at https://api.random.org/api-keys/beta)
```
export RANDOM_ORG_API_KEY="your-api-key"
```
5. Now you're good to go! Run that server!
```
rails s
```

You can run the test suite with
```
bundle exec rake spec
```


## License

MIT

## Authors

* **Oleg Larkin** - *Initial work* - [krabique48](https://github.com/krabique48) (krabique48@gmail.com)
