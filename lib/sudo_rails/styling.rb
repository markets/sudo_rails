module SudoRails
  module Styling
    def get_layout
      SudoRails.layout || 'sudo_rails/application'
    end

    def get_render
      # A proc can be passed which on #call can return a renderable view.
      return SudoRails.render.call if SudoRails.render.is_a?(Proc)

      return SudoRails.render.presence || 'sudo_rails/confirm_form'
    end

    def color_contrast(hex_color)
      return nil unless hex_color.include?('#')

      hex_color.delete('#').scan(/../).sum { |color| color.hex } > 382.5 ? '#000' : '#fff'
    end
  end
end
