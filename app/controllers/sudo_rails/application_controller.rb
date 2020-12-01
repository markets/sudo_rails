module SudoRails
  class ApplicationController < ActionController::Base
    before_action :sudo_enabled?

    def confirm
      if request.post? && SudoRails.confirm?(self, params[:password])
        session[:sudo_session] = Time.zone.now.to_s
      end

      redirect_to params[:target_path], alert: params[:alert]
    end

    private

    def sudo_enabled?
      SudoRails.enabled || head(404, message: "SudoRails disabled")
    end
  end
end
