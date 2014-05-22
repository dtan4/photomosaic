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
      context "by RGB" do
        it "should calculate color distance" do
          color_a = { red: 50, green: 100, blue: 200 }
          color_b = { red: 10, green: 20, blue: 30 }
          expect(described_class.calculate_color_distance(color_a, color_b, :rgb))
            .to be_within(0.1).of(192.0)
        end
      end

      context "by HSV" do
        it "should calculate color distance" do
          color_a = { hue: 100, saturation: 50.0, value: 70.0 }
          color_b = { hue: 50, saturation: 30.0, value: 50.0 }
          expect(described_class.calculate_color_distance(color_a, color_b, :hsv))
            .to be_within(0.1).of(57.4)
        end
      end
    end

    describe "#rgb_to_hsv" do
      it "should convert RGB to HSV" do
        rgb = { red: 50, green: 100, blue: 200 }
        hsv = described_class.rgb_to_hsv(rgb)
        expect(hsv[:hue]).to eq 220
        expect(hsv[:saturation]).to be_within(75.0).of(75.1)
        expect(hsv[:value]).to be_within(78.4).of(78.5)
      end
    end

    describe "#characteristic_color" do
      context "by RGB" do
        it "should return characteristic color" do
          characteristic_color = image.characteristic_color(:rgb)
          expect(characteristic_color[:red]).to be_within(1).of(180)
          expect(characteristic_color[:green]).to be_within(1).of(100)
          expect(characteristic_color[:blue]).to be_within(1).of(107)
        end
      end

      context "by HSV" do
        it "should return characteristic color" do
          characteristic_color = image.characteristic_color(:hsv)
          expect(characteristic_color[:hue]).to eq 354
          expect(characteristic_color[:saturation]).to be_within(0.1).of(44.7)
          expect(characteristic_color[:value]).to be_within(0.1).of(70.0)
        end
      end
    end
  end
end
