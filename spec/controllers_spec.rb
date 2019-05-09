RSpec.describe ApplicationController, type: :controller do
  it 'sudo filter skips if engine is disabled disabled' do
    SudoRails.enabled = false

    get :index

    expect(response.body).to eq("index")
  end
end

RSpec.describe SudoRails::ApplicationController, type: :controller do
  render_views

  before(:all) do
    SudoRails.confirm_strategy = -> (_, password) { password == 'foo' }
  end

  it 'redirects to target path if strategy resolves' do
    post :confirm, params: { password: 'foo', target_path: '/' }

    expect(response).to redirect_to '/'
  end

  it 'renders confirmation form again if strategy does not resolve' do
    post :confirm, params: { password: 'bar', target_path: '/' }

    expect(response.body).to match(I18n.t('sudo_rails.page_header'))
  end
end