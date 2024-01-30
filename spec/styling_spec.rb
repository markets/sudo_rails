RSpec.describe SudoRails::Styling do
  it '#color_contrast' do
    expect(SudoRails.color_contrast('#1A7191')).to eq('#fff')
    expect(SudoRails.color_contrast('#000000')).to eq('#fff')
    expect(SudoRails.color_contrast('#FFFFFF')).to eq('#000')
  end

  describe '#get_render' do
    it 'with some other view' do
      SudoRails.render = 'some_other_view'
      expect(SudoRails.get_render).to eq 'some_other_view'
    end

    it 'with an empty (blank) string' do
      SudoRails.render = ''
      expect(SudoRails.get_render).to eq 'sudo_rails/confirm_form'
    end

    it 'works with a Proc' do
      SudoRails.render = -> { 'something_within_proc' }
      expect(SudoRails.get_render).to eq 'something_within_proc'
    end
  end
end
