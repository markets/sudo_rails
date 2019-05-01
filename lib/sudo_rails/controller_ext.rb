module SudoRails
  module ControllerExt
    def sudo(options = {})
      before_action(options) do
        next unless SudoRails.enabled
        next if SudoRails::ControllerExt.valid_sudo_session?(session[:sudo_rails_session])

        render 'sudo_rails/confirm_form', layout: SudoRails.get_layout
      end
    end

    private

    def self.valid_sudo_session?(started_at)
      return false unless started_at

      Time.parse(started_at) + SudoRails.sudo_session_time > Time.zone.now
    end
  end
end
