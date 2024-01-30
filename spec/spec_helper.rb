ENV['RAILS_ENV'] = 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'sudo_rails'

RSpec.configure do |config|
  config.order = 'random'
  config.disable_monkey_patching!

  config.before do
    SudoRails.enabled = true
    SudoRails.sudo_session_duration = 10.minutes
    SudoRails.render = 'sudo_rails/confirm_form'
    SudoRails.layout = 'sudo_rails/application'
  end
end
