module SudoRails
  module ControllerExt
    extend ActiveSupport::Concern

    class_methods do
      def sudo(options = {})
        before_action(options) do
          next unless SudoRails.enabled
          next if SudoRails.valid_sudo_session?(session[:sudo_session])

          render SudoRails.get_render, layout: SudoRails.get_layout
        end
      end
    end

    def reset_sudo_session!
      session[:sudo_session] = nil
    end

    def extend_sudo_session!
      session[:sudo_session] = Time.zone.now.to_s
    end
  end
end
