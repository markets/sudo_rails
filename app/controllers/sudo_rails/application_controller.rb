module SudoRails
  class ApplicationController < ActionController::Base
    before_action :sudo_enabled?

    def confirm
      if SudoRails.confirm?(self, params[:password])
        session[:sudo_session] = Time.zone.now.to_s
      else
        flash[:alert] = I18n.t('sudo_rails.invalid_pass')
      end

      redirect_to params[:target_path]
    end

    private

    def sudo_enabled?
      SudoRails.enabled || head(404, message: "SudoRails disabled")
    end
  end
end
