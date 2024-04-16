require "sudo_rails/version"
require "sudo_rails/controller_ext"
require "sudo_rails/styling"
require "sudo_rails/engine"

module SudoRails
  class << self
    include Styling

    AVAILABLE_CALLBACKS = [
      :invalid_sudo_session,
      :new_sudo_session,
      :invalid_verification
    ]

    attr_accessor :enabled,
                  :confirm_strategy,
                  :callbacks,
                  :sudo_session_duration,
                  :reset_pass_link,
                  :layout,
                  :custom_logo,
                  :primary_color,
                  :background_color

    def setup
      yield(self) if block_given?
    end

    def confirm?(context, password)
      strategy = confirm_strategy
      raise(ArgumentError, 'Please, provide an strategy via SudoRails.confirm_strategy') unless strategy

      confirmed = strategy.call(context, password)

      if confirmed
        SudoRails.run_callback(:new_sudo_session, context)
      else
        SudoRails.run_callback(:invalid_verification, context)
      end

      confirmed
    end

    def valid_sudo_session?(started_at)
      return false unless started_at
      return true if sudo_session_duration.nil?

      DateTime.parse(started_at) + sudo_session_duration > Time.zone.now
    end

    def run_callback(type, context)
      type = type.to_sym
      if !AVAILABLE_CALLBACKS.include?(type)
        raise(ArgumentError, "Please, provide a valid callback: #{AVAILABLE_CALLBACKS.to_sentence}")
      end

      callback = callbacks[type]
      return unless callback

      callback.call(context)
    end
  end

  self.enabled = true
  self.sudo_session_duration = 30.minutes
  self.callbacks = {}
end

require 'sudo_rails/integrations/devise'    if defined?(Devise)
require 'sudo_rails/integrations/clearance' if defined?(Clearance)
