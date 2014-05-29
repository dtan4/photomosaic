require "spec_helper"
require "fileutils"
require "ostruct"

module Photomosaic
  describe Client do
    let(:api_key) { "api_key" }
    let(:base_image) { fixture_path("lena.png") }
    let(:color_model) { :rgb }
    let(:colors) { 16 }
    let(:height) { 200 }
    let(:keyword) { "keyword" }
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
       output_path: output_path,
       results: results,
       search_engine: search_engine,
       width: width
      }
    end

    let(:client) do
      described_class.new("argv")
    end

    before do
      allow(Photomosaic::Options).to receive(:parse).and_return(OpenStruct.new(options))
    end

    describe "#execute" do
      before do
        allow_any_instance_of(described_class).to receive(:pixel_images)
        allow_any_instance_of(described_class).to receive(:resize_to_pixel_size).and_return(true)
        allow(Photomosaic::Image).to receive(:create_mosaic_image).and_return(true)
      end

      it "should execute the program" do
        expect(Photomosaic::Image).to receive(:create_mosaic_image)
        client.execute
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end
    end
  end
end
