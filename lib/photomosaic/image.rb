require "RMagick"

module Photomosaic
  class Image
    def initialize(image_path)
      @image = Magick::Image.read(image_path).first
    end

    def characteristic_color
      rgb = [0, 0, 0]
      original_image = @image

      begin
        resize!(1, 1)
        rgb = pixel_color(1, 1)
      ensure
        @image = original_image
      end

      rgb
    end

    private

    def resize!(width, height)
      @image.resize!(width, height)
    end

    def pixel_color(x, y)
      rgb = @image.quantize.color_histogram.keys[pixel_index(x, y)]

      { red: rgb.red / 257, green: rgb.green / 257, blue: rgb.blue / 257 }
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
