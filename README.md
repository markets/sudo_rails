# Sudo Rails

[![Gem](https://img.shields.io/gem/v/sudo_rails.svg?style=flat-square)](https://rubygems.org/gems/sudo_rails)
[![Build Status](https://travis-ci.org/markets/sudo_rails.svg)](https://travis-ci.org/markets/sudo_rails)

> Sudo mode for your Rails controllers

Protect :lock: any Rails action with a customizable password confirmation strategy.

```ruby
class SecretController < ApplicationController
  sudo
end
```

*Inspired by Unix `sudo` command and [GitHub Sudo mode](https://help.github.com/en/articles/sudo-mode).*

## Installation

Add this line to your Gemfile and then execute `bundle install`:

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
  # On/off engine
  config.enabled = true

  # Sudo mode sessions duration, default is 1 hour
  config.sudo_session_time = 20.minutes

  # Page styles
  config.custom_logo = 'logos/medium_dark.png'
  config.primary_color = '#1A7191'
  config.layout = 'admin'

  # Confirmation strategy
  config.reset_pass_link = '/users/password/new'
  config.confirm_with = -> (context, password) {
    user = context.current_user
    user.valid_password?(password)
  }
end
```

### Styling

Using the `custom_logo` and `primary_color` options, you can customize the confimation page. In case you want full control of styles, you can use your own layout using the `layout` option.

### Confirmation strategy

You should define how to validate the password using the `confirm_with` option. It's a `lambda` that receives 2 objects: the controller instance (`context`) and the password from the user. By default, the gem comes with `Devise` integration.

Examples:

```ruby
# Devise implementation
config.confirm_with = -> (context, password) {
  user = context.current_user
  user.valid_password?(password)
}

# Other possible implementations
config.confirm_with = -> (context, password) {
  user = context.current_user
  User.authenticate?(user.email, password)
}

config.confirm_with = -> (context, password) {
  user = context.current_user
  user.admin? && password == ENV['SUPER_SECRET_PASSWORD']
}
```

## Development

Any kind of feedback, bug report, idea or enhancement are really appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add tests for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. SudoRails is released under the [MIT](LICENSE) License.
