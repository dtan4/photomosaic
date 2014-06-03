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
      describe "#create_mosaic_image" do
        let(:image_list) do
          5.times.inject([]) do |image_list, _|
            image_list << image_path_list.map { |path| described_class.new(path) }
            image_list
          end
        end

        let(:output_path) do
          tmp_path("tiled_image.jpg")
        end

        before do
          FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)
          Dir.mkdir(tmp_dir)
        end

        it "should create the mosaic image" do
          described_class.create_mosaic_image(image_list, output_path)
          expect(File.exist?(output_path)).to be_truthy
        end

        after do
          FileUtils.rm_rf(tmp_dir)
        end
      end

      describe "#preprocess_image" do
        it "should preprocess image" do
          expect_any_instance_of(described_class).to receive(:resize!).with(100, 100, true).once
          expect_any_instance_of(described_class).to receive(:posterize!).with(4).once
          expect_any_instance_of(described_class).to receive(:reduce_colors!).with(8).once
          described_class.preprocess_image(image_path, 100, 100, 4, 8)
        end
      end

      describe "#resize_images" do
        let(:image) do
          double(:resize!)
        end

        let(:image_list) do
          5.times.inject([]) do |image_list, _|
            image_list << [image]
            image_list
          end
        end

        it "should resize images" do
          expect(image).to receive(:resize!).exactly(5).times
          described_class.resize_images(image_list, 40, 20)
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

      describe "#dispatch_images" do
        let(:image_list) do
          image_path_list.map { |path| described_class.new(path) }
        end

        it "should return the map of dispatched images as a 2-dimentional array" do
          images = image.dispatch_images(image_list, 8, 8)
          expect(images.length).to eq 64
          expect(images[0].length).to eq 64
          expect(images[0][0]).to be_a described_class
        end
      end

      describe "#posterize!" do
        it "should posterize itself" do
          expect_any_instance_of(Magick::Image).to receive(:posterize).with(4)
          expect_any_instance_of(described_class).to receive(:reload_image)
          image.posterize!(4)
        end
      end

      describe "#reduce_colors!" do
        it "should reduce its colors" do
          expect_any_instance_of(Magick::Image).to receive(:quantize).with(8)
          expect_any_instance_of(described_class).to receive(:reload_image)
          image.reduce_colors!(8)
        end
      end

      describe "#resize!" do
        context "to keep aspect ratio" do
          it "should resize itself" do
            expect_any_instance_of(Magick::Image).to receive(:resize_to_fit!).with(25, 50)
            expect_any_instance_of(described_class).to receive(:reload_image)
            image.resize!(25, 50, true)
          end
        end

        context "not to keep aspect ratio" do
          it "should resize itself" do
            expect_any_instance_of(Magick::Image).to receive(:resize!).with(25, 50)
            expect_any_instance_of(described_class).to receive(:reload_image)
            image.resize!(25, 50, false)
          end
        end
      end
    end
  end
end
