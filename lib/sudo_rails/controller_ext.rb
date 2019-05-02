module SudoRails
  module ControllerExt
    def sudo(options = {})
      before_action(options) do
        next unless SudoRails.enabled
        next if SudoRails.valid_sudo_session?(session[:sudo_rails_session])

        render 'sudo_rails/confirm_form', layout: SudoRails.get_layout
      end
    end
  end
end
