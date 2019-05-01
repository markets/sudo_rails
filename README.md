> Sudo mode for your Rails controllers

Protect any Rails action with password confirmation.

```ruby
class AdminController < ApplicationController
  sudo
end
```

*Inspired by [GitHub Sudo mode](https://help.github.com/en/articles/sudo-mode).*

## Installation

Add this line to you Gemfile and then execute `bundle install`:

```ruby
gem 'sudo_rails'
```

## Usage

From now on, you have the `sudo` method available in your controllers, you can protect the whole controller or only some actions:

```ruby
class SettingsController < ApplicationController
  sudo only: :sensible_settings
end
```

### Configuration

You can use the `setup` method to customize different things:

```ruby
# config/initializers/sudo_rails.rb
SudoRails.setup do |config|
  config.enabled = true
  config.sudo_session_time = 20.minutes # default is 1 hour
  config.layout = 'admin'
  config.custom_logo = 'logos/medium_logo.png'
  config.reset_pass_link = '/users/password/new'
  config.confirm_with = -> (context, password) {
    user = context.current_user
    user.valid_password?(password)
  }
end
```

## Development

Any kind of feedback, bug report, idea or enhancement are really appreciated :tada:

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add tests for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. SudoRails is released under the [MIT](LICENSE) License.
