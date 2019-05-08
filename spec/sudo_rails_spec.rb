RSpec.describe SudoRails do
  it "#setup" do
    SudoRails.setup do |config|
      config.reset_pass_link = "/users/password/new"
    end

    expect(SudoRails.reset_pass_link).to eq "/users/password/new"
  end

  it "#confirm?" do
    SudoRails.confirm_strategy = -> (context, password) {
      password == 'foo'
    }

    expect(SudoRails.confirm?(nil, 'foo')).to be_truthy
    expect(SudoRails.confirm?(nil, 'bar')).to be_falsey
  end
end
