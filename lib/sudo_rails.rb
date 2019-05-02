require "sudo_rails/version"
require "sudo_rails/controller_ext"
require "sudo_rails/engine"

module SudoRails
  class << self
    attr_accessor :enabled,
                  :layout,
                  :custom_logo,
                  :primary_color,
                  :confirm_strategy,
                  :sudo_session_duration,
                  :reset_pass_link

    def setup
      yield(self) if block_given?
    end

    def get_layout
      layout || 'sudo_rails/application'
    end

    def custom_styles?
      primary_color.present?
    end

    def confirm?(context, password)
      strategy = confirm_strategy
      raise(ArgumentError, 'Please, provide an strategy via SudoRails.confirm_strategy') unless strategy

      strategy.call(context, password)
    end

    def valid_sudo_session?(started_at)
      return false unless started_at

      DateTime.parse(started_at) + sudo_session_duration > Time.zone.now
    end
  end

  self.enabled = true
  self.sudo_session_duration = 1.hour
end

require 'sudo_rails/integrations/devise'    if defined?(Devise)
require 'sudo_rails/integrations/clearance' if defined?(Clearance)
