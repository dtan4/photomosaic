require "spec_helper"

module Photomosaic::Color
  describe RGB do
    describe "#calculate_distance" do
      it "should calculate color distance" do
        color_a = described_class.new(50, 100, 200)
        color_b = described_class.new(10, 20, 30)

        expect(color_a.calculate_distance(color_b)).to be_within(0.5).of(192.0)
      end
    end

    describe "#to_hsv" do
      it "should convert RGB to HSV" do
        rgb = described_class.new(50, 100, 200)
        hsv = rgb.to_hsv
        expect(hsv.hue).to eq 220
        expect(hsv.saturation).to be_within(0.5).of(75.0)
        expect(hsv.value).to be_within(0.5).of(78.0)
      end
    end
  end
end
