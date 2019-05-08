ENV['RAILS_ENV'] = 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'sudo_rails'

RSpec.configure do |config|
  config.order = 'random'
  config.disable_monkey_patching!
end