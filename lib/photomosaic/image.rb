require "RMagick"

module Photomosaic
  class Image
    def self.calculate_color_distance(color_a, color_b, color_model = :rgb)
      element_names =
        color_model == :rgb ? rgb_element_names : hsv_element_names

      squares = element_names.inject([]) do |sqs, elem|
        sqs << (color_a[elem] - color_b[elem])**2
        sqs
      end

      Math.sqrt(squares.inject(&:+))
    end

    def self.rgb_to_hsv(rgb)
      rgb_element_names.each { |c| rgb[c] = rgb[c].to_f / 256 }
      rgb_max = rgb.values.max
      rgb_min = rgb.values.min

      hue = get_hue(rgb_max, rgb_min, rgb)
      saturation = (rgb_max - rgb_min) / rgb_max * 100
      value = rgb_max * 100

      { hue: hue, saturation: saturation, value: value }
    end

    def initialize(image_path)
      @image = Magick::Image.read(image_path).first
    end

    def characteristic_color(color_model = :rgb)
      rgb = [0, 0, 0]
      original_image = @image

      begin
        resize!(1, 1)
        rgb = pixel_color(1, 1)
      ensure
        @image = original_image
      end

      color_model == :rgb ? rgb : self.class.rgb_to_hsv(rgb)
    end

    private

    def self.rgb_element_names
      [:red, :green, :blue]
    end

    def self.hsv_element_names
      [:hue, :saturation, :value]
    end

    def self.get_hue(rgb_max, rgb_min, rgb)
      _hue = case rgb_max
             when rgb_min
               -1
             when rgb[:red]
               ((rgb[:green] - rgb[:blue]) / (rgb_max - rgb_min)) % 6
             when rgb[:green]
               (rgb[:blue] - rgb[:red]) / (rgb_max - rgb_min) + 2
             else
               (rgb[:red] - rgb[:green]) / (rgb_max - rgb_min) + 4
             end

      (_hue * 60).to_i if _hue > 0
    end

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
