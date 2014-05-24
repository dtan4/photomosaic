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
      context "by RGB" do
        it "should return characteristic color in RGB" do
          characteristic_color = image.characteristic_color(:rgb)
          expect(characteristic_color.red).to be_within(1).of(180)
          expect(characteristic_color.green).to be_within(1).of(100)
          expect(characteristic_color.blue).to be_within(1).of(107)
        end
      end

      context "by HSV" do
        it "should return characteristic color in HSV" do
          characteristic_color = image.characteristic_color(:hsv)
          expect(characteristic_color.hue).to eq 354
          expect(characteristic_color.saturation).to be_within(0.5).of(44.7)
          expect(characteristic_color.value).to be_within(0.5).of(70.0)
        end
      end
    end

    describe "#resize!" do
      it "should resize itself" do
        expect_any_instance_of(Magick::Image).to receive(:resize!).with(50, 50)
        image.resize!(50, 50)
      end
    end
  end
end
