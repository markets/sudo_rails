require "sudo_rails/version"
require "sudo_rails/controller_ext"
require "sudo_rails/engine"

module SudoRails
  class << self
    attr_accessor :enabled,
                  :layout,
                  :custom_logo,
                  :primary_color,
                  :confirm_with,
                  :sudo_session_time,
                  :reset_pass_link

    def setup
      yield(self) if block_given?
    end

    def get_layout
      layout || 'sudo_rails/application'
    end
  end

  self.enabled = true
  self.sudo_session_time = 1.hour

  if defined?(Devise)
    self.confirm_with = -> (context, password) {
      user = context.current_user
      user.valid_password?(password)
    }
    self.reset_pass_link = "/users/password/new"
  end
end
