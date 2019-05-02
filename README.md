# Sudo Rails

[![Gem](https://img.shields.io/gem/v/sudo_rails.svg?style=flat-square)](https://rubygems.org/gems/sudo_rails)
[![Build Status](https://travis-ci.org/markets/sudo_rails.svg)](https://travis-ci.org/markets/sudo_rails)

> Sudo mode for your Rails controllers

:lock: Protect any Rails action with a customizable password confirmation strategy.

```ruby
class SecretController < ApplicationController
  sudo
end
```

*Inspired by [Unix `sudo` command](https://en.wikipedia.org/wiki/Sudo) and [GitHub Sudo mode](https://help.github.com/en/articles/sudo-mode).*

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

You can use the `setup` method to configure and customize different things:

```ruby
# config/initializers/sudo_rails.rb
SudoRails.setup do |config|
  # On/off engine
  config.enabled = true

  # Sudo mode sessions duration, default is 1 hour
  config.sudo_session_duration = 20.minutes

  # Default confirmation page styles
  config.custom_logo = 'logos/medium_dark.png'
  config.primary_color = '#1A7191'
  config.layout = 'admin'

  # Confirmation strategy
  config.confirm_strategy = -> (context, password) {
    user = context.current_user
    user.valid_password?(password)
  }
  config.reset_pass_link = '/users/password/new'
end
```

### Styling

Using the `custom_logo` and `primary_color` options, you can customize the confirmation page. In case you want full control of the styles, you can use your own layout (and consequently your own styles too) using the `layout` option.

### Confirmation strategy

You should define how to validate the password using the `confirm_strategy` option. It must be a `lambda`, which will receive 2 arguments: the controller instance (`context`) and the password from the user.

By default, the gem ships with `Devise` and `Clearance` integration.

Implementation examples:

```ruby
# Devise implementation
config.confirm_strategy = -> (context, password) {
  user = context.current_user
  user.valid_password?(password)
}

# has_secure_password implementation
config.confirm_strategy = -> (context, password) {
  user = context.current_user
  user.authenticate(password)
}

# Other custom implementation
config.confirm_strategy = -> (context, password) {
  user = context.current_user
  user.admin? && password == ENV['SUPER_SECRET_PASSWORD']
}

config.confirm_strategy = -> (context, password) {
  Auth.call(context.current_user.email, password)
}
```

### I18n

`sudo_rails` uses I18n by default. Take a look at our [locale file](config/locales/en.yml) to check all available messages.

## Development

Any kind of feedback, bug report, idea or enhancement are really appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add tests for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. SudoRails is released under the [MIT](LICENSE) License.
