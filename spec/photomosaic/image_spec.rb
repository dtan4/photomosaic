require "spec_helper"

module Photomosaic
  describe Image do
    let(:image_path) do
      fixture_path("lena.png")
    end

    let(:image) do
      described_class.new(image_path)
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
