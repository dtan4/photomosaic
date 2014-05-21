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
        color_a = { red: 100, green: 200, blue: 300 }
        color_b = { red: 10, green: 20, blue: 30 }
        expect(described_class.calculate_color_distance(color_a, color_b))
          .to be_within(336.7).of(336.8)
      end
    end

    describe "#characteristic_color" do
      it "should return characteristic color" do
        expect(image.characteristic_color[:red]).to be_within(179).of(181)
        expect(image.characteristic_color[:green]).to be_within(98).of(100)
        expect(image.characteristic_color[:blue]).to be_within(105).of(107)
      end
    end
  end
end
