SudoRails.setup do |config|
  config.confirm_strategy = -> (context, password) {
    user = context.current_user
    user.valid_password?(password)
  }
  config.reset_pass_link = "/users/password/new"
end

