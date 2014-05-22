require "spec_helper"

module Photomosaic
  describe Image do
    let(:image_path) do
      fixture_path("lena.png")
    end

    let(:image) do
      described_class.new(image_path)
    end

    describe "#calculate_color_distance" do
      it "should calculate color distance" do
        color_a = { red: 50, green: 100, blue: 200 }
        color_b = { red: 10, green: 20, blue: 30 }
        expect(described_class.calculate_color_distance(color_a, color_b))
          .to be_within(192.0).of(192.1)
      end
    end

    describe "#rgb_to_hsv" do
      it "should convert RGB to HSV" do
        rgb = { red: 50, green: 100, blue: 200 }
        hsv = described_class.rgb_to_hsv(rgb)
        expect(hsv[:hue]).to be_within(220.0).of(220.1)
        expect(hsv[:saturation]).to be_within(75.0).of(75.1)
        expect(hsv[:value]).to be_within(78.4).of(78.5)
      end
    end

    describe "#characteristic_color" do
      it "should return characteristic color" do
        characteristic_color = image.characteristic_color
        expect(characteristic_color[:red]).to be_within(179).of(181)
        expect(characteristic_color[:green]).to be_within(98).of(100)
        expect(characteristic_color[:blue]).to be_within(105).of(107)
      end
    end
  end
end
