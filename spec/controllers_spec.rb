RSpec.describe ApplicationController, type: :controller do
  render_views

  describe 'sudo filter' do
    it 'skips if engine is disabled' do
      SudoRails.enabled = false

      get :index

      expect(response.body).to eq("index")
    end

    it 'renders confirmation form if engine is enabled' do
      get :index

      expect(response.body).to match(I18n.t('sudo_rails.page_header'))
    end

    it 'runs the invalid_sudo_session callback' do
      SudoRails.callbacks = {
        invalid_sudo_session: -> (_) { puts "Invalid sudo session!" }
      }

      expect {
        get :index
      }.to output("Invalid sudo session!\n").to_stdout
    end
  end

  describe 'provided helpers' do
    it '#reset_sudo_session!' do
      @controller.reset_sudo_session!

      expect(session[:sudo_session]).to be nil
    end

    it '#extend_sudo_session!' do
      @controller.extend_sudo_session!

      expect(session[:sudo_session]).not_to be nil
    end
  end
end

RSpec.describe SudoRails::ApplicationController, type: :controller do
  before(:all) do
    SudoRails.confirm_strategy = -> (_, password) { password == 'foo' }
    @target_path = '/'
  end

  it 'if strategy resolves, redirects to target path with a valid sudo session' do
    post :confirm, params: { password: 'foo', target_path: @target_path }

    expect(SudoRails.valid_sudo_session?(session[:sudo_session])).to eq(true)
    expect(response).to redirect_to @target_path
    expect(flash[:alert]).to be nil
  end

  it 'if strategy does not resolve, redirects to target with an invalid sudo session' do
    post :confirm, params: { password: 'bar', target_path: @target_path }

    expect(SudoRails.valid_sudo_session?(session[:sudo_session])).to eq(false)
    expect(response).to redirect_to @target_path
    expect(flash[:alert]).to eq I18n.t('sudo_rails.invalid_pass')
  end
end
