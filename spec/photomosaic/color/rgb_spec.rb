require "spec_helper"

module Photomosaic
  module Color
    describe RGB do
      describe "#calculate_distance" do
        it "should calculate color distance" do
          color_a = described_class.new(50, 100, 200)
          color_b = described_class.new(10, 20, 30)

          expect(color_a.calculate_distance(color_b)).to be_within(0.5).of(192.0)
        end
      end

      describe "#to_hsv" do
        # cf. http://tech-unlimited.com/color.html

        it "should convert (50, 50, 50) to (0, 0, 20)" do
          rgb = described_class.new(50, 50, 50)
          hsv = rgb.to_hsv
          expect(hsv.hue).to eq 0
          expect(hsv.saturation).to be_within(1).of(0)
          expect(hsv.value).to be_within(1).of(20)
        end

        it "should convert (50, 100, 200) to (220, 75, 78)" do
          rgb = described_class.new(50, 100, 200)
          hsv = rgb.to_hsv
          expect(hsv.hue).to eq 220
          expect(hsv.saturation).to be_within(1).of(75)
          expect(hsv.value).to be_within(1).of(78)
        end

        it "should convert (100, 50, 200) to (260, 75, 78)" do
          rgb = described_class.new(100, 50, 200)
          hsv = rgb.to_hsv
          expect(hsv.hue).to eq 260
          expect(hsv.saturation).to be_within(1).of(75)
          expect(hsv.value).to be_within(1).of(78)
        end

        it "should convert (100, 200, 50) to (100, 75, 78)" do
          rgb = described_class.new(100, 200, 50)
          hsv = rgb.to_hsv
          expect(hsv.hue).to eq 100
          expect(hsv.saturation).to be_within(1).of(75)
          expect(hsv.value).to be_within(1).of(78)
        end
      end
    end
  end
end
