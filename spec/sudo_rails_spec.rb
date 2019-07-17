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

    expect(SudoRails.confirm?(nil, 'foo')).to eq true
    expect(SudoRails.confirm?(nil, 'bar')).to eq false
  end

  it "#valid_sudo_session?" do
    timestamp = Time.zone.now
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq true

    timestamp = timestamp - (SudoRails.sudo_session_duration + 1.minute)
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq false

    SudoRails.sudo_session_duration = nil
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq true
  end
end
