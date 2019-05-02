module SudoRails
  class ApplicationController < ActionController::Base
    before_action :sudo_enabled?

    def confirm
      if request.post? && SudoRails.confirm?(self, params[:password])
        session[:sudo_rails_session] = Time.zone.now
        redirect_to params[:target_path]
      else
        render 'sudo_rails/confirm_form', layout: SudoRails.get_layout
      end
    end

    private

    def sudo_enabled?
      SudoRails.enabled || head(404, message: "SudoRails disabled")
    end
  end
end
