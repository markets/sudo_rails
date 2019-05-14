RSpec.describe SudoRails::Styling do
  it '#color_contrast' do
    expect(SudoRails.color_contrast('#1A7191')).to eq('#FFF')
    expect(SudoRails.color_contrast('#000000')).to eq('#FFF')
    expect(SudoRails.color_contrast('#FFFFFF')).to eq('#000')
  end
end
