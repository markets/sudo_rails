class ApplicationController < ActionController::Base
  sudo

  def index
    render plain: 'index'
  end
end
