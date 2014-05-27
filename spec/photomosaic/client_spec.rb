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

    let(:argv) { "argv" }

    let(:image_name_list) do
      (0..5).map { |i| "lena_#{i}.png" }
    end

    let(:image_path_list) do
      image_name_list.map { |name| fixture_path(name) }
    end

    let(:image_url_list) do
      image_name_list.map { |name| "http://example.com/#{name}" }
    end

    let(:preprocessed_image) do
      # TODO: Use mock
      Photomosaic::Image.new(base_image)
    end

    let(:dispatched_images) do
      5.times.inject([]) do |images, _|
        # TODO: Use mock
        images << image_path_list.map { |path| Photomosaic::Image.new(path) }
        images
      end
    end

    describe "#execute" do
      before do
        allow(Photomosaic::Options).to receive(:parse).and_return(OpenStruct.new(options))
        allow_any_instance_of(Photomosaic::SearchEngine::Bing).to receive(:get_image_list)
          .with(keyword).and_return(image_url_list)
        allow(Photomosaic::Image).to receive(:preprocess_image).and_return(preprocessed_image)
        allow_any_instance_of(Photomosaic::ImageDownloader).to receive(:download_images)
          .and_return(image_path_list)
        allow_any_instance_of(Photomosaic::Image).to receive(:dispatch_images)
          .and_return(dispatched_images)

        FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)
        Dir.mkdir(tmp_dir)
      end

      it "should execute the program" do
        described_class.execute(argv)
        expect(File.exist?(output_path)).to be_true
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end
    end
  end
end
