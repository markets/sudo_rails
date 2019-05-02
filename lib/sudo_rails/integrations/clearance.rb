SudoRails.setup do |config|
  config.confirm_strategy = -> (context, password) {
    user = context.current_user
    user.authenticated?(password)
  }
  config.reset_pass_link = "/passwords/new"
end
