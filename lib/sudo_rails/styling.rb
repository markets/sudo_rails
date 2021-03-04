module SudoRails
  module Styling
    def get_layout
      SudoRails.layout || 'sudo_rails/application'
    end

    def color_contrast(hex_color)
      return nil unless hex_color.include?('#')

      hex_color.delete('#').scan(/../).sum { |color| color.hex } > 382.5 ? '#000000' : '#FFFFFF'
    end
  end
end
