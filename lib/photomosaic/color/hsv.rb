module Photomosaic::Color
  class HSV
    attr_reader :hue, :saturation, :value

    def initialize(hue, saturation, value)
      @hue = hue
      @saturation = saturation
      @value = value
    end

    def calculate_distance(hsv)
      squares = [
                 (self.hue - hsv.hue)**2,
                 (self.saturation - hsv.saturation)**2,
                 (self.value - hsv.value)**2
                ]

      Math.sqrt(squares.inject(&:+))
    end
  end
end
