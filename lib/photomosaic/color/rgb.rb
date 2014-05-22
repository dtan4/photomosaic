module Photomosaic::Color
  class RGB
    attr_reader :red, :green, :blue

    def initialize(red, green, blue)
      @red = red
      @green = green
      @blue = blue
    end

    def max
      @max ||= [@red, @green, @blue].max.to_f
    end

    def min
      @min ||= [@red, @green, @blue].min.to_f
    end

    def to_hsv
      HSV.new(hue, saturation, value)
    end

    def calculate_distance(rgb)
      squares = [
                 (self.red - rgb.red)**2,
                 (self.green - rgb.green)**2,
                 (self.blue - rgb.blue)**2
                ]

      Math.sqrt(squares.inject(&:+))
    end

    private

    def hue
      return -1 if max == min

      _hue = case max
             when @red.to_f
               ((@green - @blue) / (max - min)) % 6
             when @green.to_f
               (@blue - @red) / (max - min) + 2
             else
               (@red - @green) / (max - min) + 4
             end

      (_hue * 60).to_i
    end

    def saturation
      (max - min) / max * 100
    end

    def value
      max * 100 / 256
    end
  end
end
