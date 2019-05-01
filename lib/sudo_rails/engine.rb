module SudoRails
  class Engine < ::Rails::Engine
    isolate_namespace SudoRails

    initializer "sudo_rails.controller_ext" do
      ActiveSupport.on_load(:action_controller) do
        extend SudoRails::ControllerExt
      end
    end

    initializer 'sudo_rails.routes' do |app|
      app.routes.append do
        match '/sudo_rails/confirm' => 'sudo_rails/application#confirm', via: [:get, :post]
      end
    end

    config.assets.precompile << %w(
      sudo_rails/application.css
    )
  end
end
