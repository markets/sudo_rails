class SudoRails::ViewGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../app/views/sudo_rails/", __dir__)

  def copy_initializer_file
    copy_file "confirm_form.html.erb", "app/views/sudo_rails/confirm_form.html.erb"
  end
end