module SudoRails
  class ApplicationController < ActionController::Base
    before_action :sudo_enabled?

    def confirm
      if SudoRails.confirm?(self, params[:password])
        extend_sudo_session!
      else
        flash[:alert] = I18n.t('sudo_rails.invalid_pass', locale: params[:locale])
      end

      redirect_to params[:target_path]
    end

    private

    def sudo_enabled?
      SudoRails.enabled || head(404, message: "SudoRails disabled")
    end
  end
end
