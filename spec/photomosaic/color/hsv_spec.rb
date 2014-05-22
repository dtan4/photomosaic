require "spec_helper"

module Photomosaic::Color
  describe HSV do
    describe "#calculate_distance" do
      it "should calculate color distance" do
        color_a = described_class.new(100, 50.0, 70.0)
        color_b = described_class.new(50, 30.0, 50.0)

        expect(color_a.calculate_distance(color_b)).to be_within(0.1).of(57.4)
      end
    end
  end
end
