module Photomosaic::Color
  class HSV
    attr_reader :hue, :saturation, :value

    def initialize(hue, saturation, value)
      @hue = hue
      @saturation = saturation
      @value = value
    end

    def calculate_distance(hsv)
      Math.sqrt(squares_array(hsv).inject(&:+))
    end

    private

    def squares_array(hsv)
      [
       (self.hue - hsv.hue)**2,
       (self.saturation - hsv.saturation)**2,
       (self.value - hsv.value)**2
      ]
    end
  end
end
