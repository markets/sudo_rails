RSpec.describe SudoRails do
  it "#confirm?" do
    SudoRails.setup do |config|
      config.confirm_strategy = -> (context, password) {
        password == 'foo'
      }
      config.callbacks = {
        new_sudo_session: -> (_) { puts "New sudo session" },
        invalid_verification: -> (_) { puts "Invalid pass" }
      }
    end

    expect(SudoRails.confirm?(nil, 'foo')).to eq true
    expect(SudoRails.confirm?(nil, 'bar')).to eq false

    # Check also expected callbacks
    expect { SudoRails.confirm?(nil, 'foo') }.to output("New sudo session\n").to_stdout
    expect { SudoRails.confirm?(nil, 'bar') }.to output("Invalid pass\n").to_stdout
  end

  it "#valid_sudo_session?" do
    timestamp = Time.zone.now
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq true

    timestamp = timestamp - (SudoRails.sudo_session_duration + 1.minute)
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq false

    SudoRails.sudo_session_duration = nil
    expect(SudoRails.valid_sudo_session?(timestamp.to_s)).to eq true
  end

  it "#run_callback" do
    expect {
      SudoRails.run_callback(:invalid_callback, nil)
    }.to raise_error(/provide a valid callback/)
  end
end
