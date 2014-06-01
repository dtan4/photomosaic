require "spec_helper"
require "ostruct"

module Photomosaic
  describe Client do
    let(:api_key) { "api_key" }
    let(:base_image) { fixture_path("lena.png") }
    let(:color_model) { :rgb }
    let(:colors) { 16 }
    let(:height) { 200 }
    let(:keyword) { "keyword" }
    let(:level) { 4 }
    let(:output_path) { tmp_path("output.png") }
    let(:results) { 50 }
    let(:search_engine) { SearchEngine::Bing }
    let(:width) { 200 }

    let(:options) do
      {
       api_key: api_key,
       base_image: base_image,
       color_model: color_model,
       colors: colors,
       height: height,
       keyword: keyword,
       level: level,
       output_path: output_path,
       results: results,
       search_engine: search_engine,
       width: width
      }
    end

    let(:client) do
      described_class.new("argv")
    end

    let(:dispatched_images)  do
      [
       [image],
       [image],
       [image]
      ]
    end

    let(:image) do
      double(Photomosaic::Image)
    end

    let(:image_name_list) do
      [
       "lena_0.png",
       "lena_1.png",
       "lena_2.png",
       "notfound.png"
      ]
    end

    let(:image_path_list) do
      image_name_list.map { |name| fixture_path(name) }
    end

    let(:image_url_list) do
      image_name_list.map { |name| "http://example.com/#{name}" }
    end

    before do
      allow(Photomosaic::Options).to receive(:parse).and_return(OpenStruct.new(options))
    end

    describe "#execute" do
      before do
        allow_any_instance_of(Photomosaic::SearchEngine::Bing).to receive(:get_image_list).and_return(image_url_list)
        allow_any_instance_of(Photomosaic::ImageDownloader).to receive(:download_images).and_return(image_path_list)
        allow(Photomosaic::Image).to receive(:create_mosaic_image)
        allow(Photomosaic::Image).to receive(:new).with(/lena(?:_\d)?\.png/).and_return(image)
        allow(Photomosaic::Image).to receive(:new).with(/notfound.png/).and_raise Magick::ImageMagickError
        allow(Photomosaic::Image).to receive(:resize_to_pixel_size)
        allow(image).to receive(:dispatch_images).and_return(dispatched_images)
        allow(image).to receive(:posterize!)
        allow(image).to receive(:reduce_colors!)
        allow(image).to receive(:resize!)
      end

      it "should execute the program" do
        expect(Photomosaic::Image).to receive(:create_mosaic_image)
        client.execute
      end
    end
  end
end
