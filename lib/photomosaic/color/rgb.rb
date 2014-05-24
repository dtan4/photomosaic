module Photomosaic::Color
  class RGB
    attr_reader :red, :green, :blue

    def initialize(red, green, blue)
      @red = red
      @green = green
      @blue = blue
    end

    def max
      @max ||= [@red, @green, @blue].max
    end

    def min
      @min ||= [@red, @green, @blue].min
    end

    def to_hsv
      HSV.new(hue, saturation, value)
    end

    def calculate_distance(rgb)
      Math.sqrt(squares_array(rgb).inject(&:+))
    end

    private

    def hue
      return -1 if max == min

      _hue = case max
             when @red
               ((@green - @blue).to_f / (max - min)) % 6
             when @green
               (@blue - @red).to_f / (max - min) + 2
             else
               (@red - @green).to_f / (max - min) + 4
             end

      (_hue * 60).to_i
    end

    def saturation
      (max - min).to_f / max * 100
    end

    def squares_array(rgb)
      [
       (self.red - rgb.red)**2,
       (self.green - rgb.green)**2,
       (self.blue - rgb.blue)**2
      ]
    end

    def value
      (max * 100).to_f / 256
    end
  end
end
