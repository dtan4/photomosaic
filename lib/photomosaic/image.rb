require "RMagick"

module Photomosaic
  class Image
    def initialize(image_path)
      @image = Magick::Image.read(image_path).first
    end

    def characteristic_color(color_model = :rgb)
      rgb = nil
      original_image = @image

      begin
        resize!(1, 1)
        rgb = pixel_color(1, 1)
      ensure
        @image = original_image
      end

      color_model == :rgb ? rgb : rgb.to_hsv
    end

    def resize!(width, height)
      @image.resize!(width, height)
    end

    private

    def pixel_color(x, y)
      rgb = @image.quantize.color_histogram.keys[pixel_index(x, y)]

      Color::RGB.new(rgb.red / 257, rgb.green / 257, rgb.blue / 257)
    end

    def pixel_index(x, y)
      (y - 1) * image_width + (x - 1)
    end

    def image_height
      @image.rows
    end

    def image_width
      @image.columns
    end
  end
end
