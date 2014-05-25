require "spec_helper"
require "fileutils"
require "tempfile"

module Photomosaic
  describe Image do
    let(:image_path) do
      fixture_path("lena.png")
    end

    let(:image_path_list) do
      [
       fixture_path("lena_0.png"),
       fixture_path("lena_1.png"),
       fixture_path("lena_2.png"),
       fixture_path("lena_3.png"),
       fixture_path("lena_4.png"),
       fixture_path("lena_5.png")
      ]
    end

    context "class methods" do
      let(:output_path) do
        tmp_path("tiled_image.jpg")
      end

      describe "#create_tiled_image" do
        before do
          FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)
          Dir.mkdir(tmp_dir)
        end

        it "should create tiled image" do
          described_class.create_tiled_image(image_path_list, 2, 3, output_path)
          expect(File.exist?(output_path)).to be_true
        end

        after do
          FileUtils.rm_rf(tmp_dir)
        end
      end

      describe "#preprocess_image" do
        it "should preprocess image" do
          expect_any_instance_of(described_class).to receive(:resize!).once
          expect_any_instance_of(described_class).to receive(:posterize!).once
          expect_any_instance_of(described_class).to receive(:reduce_colors!).once
          described_class.preprocess_image(image_path)
        end
      end
    end

    context "instance methods" do
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

      describe "#colors_of_pixels" do
        it "should return the colors of pixles as a 2-dimentional array" do
          colors = image.colors_of_pixels(1, 2)
          expect(colors).to have(512).items
          expect(colors[0]).to have(256).items
        end

        context "by RGB" do
          it "should return the colors of pixels in RGB" do
            colors = image.colors_of_pixels(1, 2)
            expect(colors[0][0]).to be_a Photomosaic::Color::RGB
          end
        end

        context "by HSV" do
          it "should return the colors of pixels in HSV" do
            colors = image.colors_of_pixels(1, 2, :hsv)
            expect(colors[0][0]).to be_a Photomosaic::Color::HSV
          end
        end
      end

      describe "#dispatch_images" do
        let(:image_list) do
          image_path_list.map { |path| described_class.new(path) }
        end

        it "should return the map of dispatched images as a 2-dimentional array" do
          images = image.dispatch_images(image_list, 8, 8)
          expect(images).to have(64).items
          expect(images[0]).to have(64).items
          expect(images[0][0]).to be_a described_class
        end
      end

      describe "#posterize!" do
        it "should posterize itself" do
          expect_any_instance_of(Magick::Image).to receive(:posterize).with(4)
          image.posterize!
        end
      end

      describe "#reduce_colors!" do
        it "should reduce its colors" do
          expect_any_instance_of(Magick::Image).to receive(:quantize).with(8)
          image.reduce_colors!
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
end
