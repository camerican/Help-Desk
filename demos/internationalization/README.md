# International Rock Paper Scissors

This is a demo of i18n with a mock rock paper scissors application.  The main focus of the application is to have versions for English, French, and Turkish.

## Preliminaries

We'll use devise to manage user accounts and use the devise i18n gem to provide support for many languages.  To get going, let's add `gem 'devise'` and `gem 'devise-i18n'` to the `Gemfile`.

Next, we'll run `bundle install`.

And then `rails g devise:install`

We'll next configure the mail server in the `development.rb` file.

```ruby
# Use localhost as mail server
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

Now we'll set up devise with a user model and add in a username and first and last name.

```bash
rails g devise user username:string first_name:string last_name:string
```

We'll also set up a game model to handle the playing of the game:

```bash
rails g model game user:references threw:integer against:integer result:integer
```

And we'll run our migration to get our two tables loaded into our database.

```bash
rails db:migrate
```

## Setting up the Game Model

Let's add in enumerables for the `threw`, `against`, and `result` columns.

```ruby
class Game < ApplicationRecord
  belongs_to :user
  @@moves = [:rock, :paper, :scissors]
  enum threw: @@moves
  enum against: @@moves
  enum result: [:loss, :draw, :win]
end
```

We've enumerated rock, paper, and scissors with the following values:

| move | enum |
| --- | --- |
| rock | 0 |
| paper | 1 |
| scissors | 2 |

Let's also add in a couple methods to throw a random move and to determine who won based on the following results table.

| Calculation | Result | Num | Explanation |
| --- | --- | --- | --- |
| (4 + 0 - 0) % 3 = 1 | :draw | 1 | Rock draws with Rock |
| (4 + 0 - 1) % 3 = 0 | :loss | 0 | Rock loses to Paper |
| (4 + 0 - 2) % 3 = 2 | :win  | 2 | Rock beats Scissors |
| (4 + 1 - 0) % 3 = 2 | :win  | 2 | Paper beats Rock |
| (4 + 1 - 1) % 3 = 2 | :draw | 1 | Paper draws with Paper |
| (4 + 1 - 2) % 3 = 0 | :loss | 0 | Paper loses to Scissors |
| (4 + 2 - 0) % 3 = 0 | :loss | 0 | Scissors loses to Rock |
| (4 + 2 - 1) % 3 = 2 | :win  | 2 | Scissors beats Paper |
| (4 + 2 - 2) % 3 = 1 | :draw | 1 | Scissors draws with Scissors |

We'll add the following methods to `game.rb`.

```ruby
# app/models/game.rb

# determine result
def determine_result
  (4 + threw - against) % 3
end
# perform a random move
def self.move
  @@moves.sample
end
```

## User model

Let's made sure we add in a `has_many` relation within the user model.

```
has_many :games
```

## Internationalizing with the i18n gem

We'll now get busy setting our application up for internationalization.  We'll add in routes within a `:locale` scope as follows:

```ruby
# config/routes.rb

scope "/:locale" do
  root to: 'home#index'
  post '/:move' => 'home#play', constraints: { id: /(rock|paper|scissors)/ }
end
```

We set up a post route to handle the moves that the user is going to be placing.
