module SudoRails
  module Styling
    def get_layout
      SudoRails.layout || 'sudo_rails/application'
    end

    def custom_styles?
      SudoRails.primary_color.present? || SudoRails.background_color.present?
    end

    # Ref: https://gist.github.com/charliepark/480358
    def color_contrast(hex_color)
      return nil unless hex_color.include?('#')

      hex_color.delete('#').scan(/../).sum { |color| color.hex } > 382.5 ? '#000' : '#FFF'
    end
  end
end
