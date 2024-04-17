# Sudo Rails

[![Gem](https://img.shields.io/gem/v/sudo_rails.svg?style=flat-square)](https://rubygems.org/gems/sudo_rails)
[![Build Status](https://github.com/markets/sudo_rails/workflows/CI/badge.svg)](https://github.com/markets/sudo_rails/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/322350adc7ab052beccb/maintainability)](https://codeclimate.com/github/markets/sudo_rails/maintainability)

> Sudo mode for your Rails controllers

:lock: Protect any Rails action with a customizable password confirmation strategy.

```ruby
class SecretController < ApplicationController
  sudo
end
```

*Inspired by [Unix `sudo` command](https://en.wikipedia.org/wiki/Sudo) and [GitHub Sudo mode](https://help.github.com/en/articles/sudo-mode).*

![](support/images/cover.png)

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

Under the hood, the `sudo` method delegates to a `before_action` callback, so you're able to pass the following options: `:only`, `:except`, `:if` and `:unless`.

The gem also provides a couple of controller helpers, useful to manually manage the `sudo` session status:

- `reset_sudo_session!`: resets the current sudo session, if any.
- `extend_sudo_session!`: marks the current session as a valid sudo session.

### Configuration

You can use the `setup` method to configure and customize different things:

```ruby
# config/initializers/sudo_rails.rb
SudoRails.setup do |config|
  # On/off engine
  config.enabled = true

  # Sudo mode sessions duration, default is 30 minutes
  config.sudo_session_duration = 10.minutes

  # Confirmation page styling
  config.custom_logo = '/images/logo_medium.png'
  config.primary_color = '#1a7191'
  config.background_color = '#1a1a1a'
  config.layout = 'admin'

  # Confirmation strategy implementation
  config.confirm_strategy = -> (context, password) {
    user = context.current_user
    user.valid_password?(password)
  }

  # Reset password link
  config.reset_pass_link = '/users/password/new'

  # Subscribe to different events
  config.callbacks = {
    invalid_sudo_session: -> (context) {
      user = context.current_user
      AuthService.send_code(user)
    },
    invalid_confirmation: -> (context) {
      user = context.current_user
      Rails.logger.warn("[SUDO_RAILS] invalid password for #{user.email}")
    }
  }
end
```

Use the provided `sudo_rails:config` generator to create a default config file under your *initializers* folder.

### Sudo sessions

Using the `sudo_session_duration` option you are able to configure the `sudo` session duration (30 minutes by default).

If you set it to `nil`, your `sudo` session won't expire automatically and you will have to do it manually by using the `reset_sudo_session!` helper.

### Styling

Using the `custom_logo`, `primary_color` and `background_color` options, you can customize the confirmation page. In case you want full control of the styles, you can use your own layout (and consequently your own styles too) using the `layout` option.

See some :camera: [examples here](support/images/examples/).

> ℹ️ If you are using your own layout, don't forget to render the flash messages in that layout. You can do something [like this](app/views/sudo_rails/_flash_alert.html.erb).

You can also override the view by calling the `sudo_rails:view` generator. This will create a copy of the view file at `app/views/sudo_rails/confirm_form.html.erb` which can be later modified as per your requirements.

### Confirmation strategy

You should define how to validate the password using the `confirm_strategy` option. It must be a `lambda`, which will receive 2 arguments: the controller instance (`context`) and the password from the user.

By default, the gem ships with `Devise` and `Clearance` integration. Check it [here](lib/sudo_rails/integrations/).

> ℹ️ In order to autoload `Devise` or `Clearance` strategy properly, you should place the `sudo_rails` gem after them in the Gemfile.

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

# Another example, using ENV vars
config.confirm_strategy = -> (context, password) {
  user = context.current_user
  user.admin? && password == ENV['SUPER_SECRET_PASSWORD']
}
```

### Callbacks

You can subscribe to different lifecycle events via the `callbacks` option. Each callback must be a `lambda`, which will receive 1 argument, the controller instance (`context`).

You can subscribe to the following events:

- `:invalid_sudo_session`: fired when the confirmation page is rendered, because there is no valid sudo session. Be careful! If the page is re-submitted or the password is invalid, the confirmation page will be rendered again and this event will be fired again too.
- `:new_sudo_session`: fired when a new sudo session is started.
- `:invalid_confirmation`: fired when an invalid password is submitted.

This can be really useful for example for instrumentation or logging:

```ruby
config.callbacks = {
  invalid_confirmation: -> (context) {
    user = context.current_user
    request = context.request

    Rails.logger.warn("[SUDO_RAILS] Invalid verification: #{user.email} - #{request.remote_ip}")
  }
}
```

Or you can even implement custom workflows along with the `confirm_strategy` option. Like for example, using your 2FA system instead of the session password:

```ruby
config.callbacks = {
  invalid_sudo_session: -> (context) {
    user = context.current_user
    AuthService.send_code(user)
  }
}

config.confirm_strategy = -> (context, code) {
  user = context.current_user
  AuthService.validate_code(user, code)
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
