require "spec_helper"
require "fileutils"

module Photomosaic
  describe Client do
    let(:api_key) { "api_key" }
    let(:base_image) { fixture_path("lena.png") }
    let(:color_model) { :rgb }
    let(:height) { 200 }
    let(:keyword) { "keyword" }
    let(:number_colors) { 16 }
    let(:number_results) { 50 }
    let(:output_path) { tmp_path("output.png") }
    let(:search_engine) { SearchEngine::Bing }
    let(:width) { 200 }

    let(:options) do
      {
       api_key: api_key,
       base_image: base_image,
       color_model: color_model,
       height: height,
       keyword: keyword,
       number_colors: number_colors,
       number_results: number_results,
       output: output_path,
       search_engine: search_engine,
       width: width
      }
    end

    let(:image_name_list) do
      (0..5).map { |i| "lena_#{i}.png" }
    end

    let(:image_path_list) do
      image_name_list.map { |name| fixture_path(name) }
    end

    let(:image_url_list) do
      image_name_list.map { |name| "http://example.com/#{name}" }
    end

    let(:dispatched_images) do
      5.times.inject([]) do |images, _|
        # TODO: Use mock
        images << image_path_list.map { |path| Photomosaic::Image.new(path) }
        images
      end
    end

    describe "#run" do
      before do
        allow_any_instance_of(Photomosaic::SearchEngine::Bing).to receive(:get_image_list)
          .with(keyword).and_return(image_url_list)
        allow_any_instance_of(Photomosaic::ImageDownloader).to receive(:download_images)
          .and_return(image_path_list)
        allow_any_instance_of(Photomosaic::Image).to receive(:dispatch_images)
          .and_return(dispatched_images)

        FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)
        Dir.mkdir(tmp_dir)
      end

      it "should run the program" do
        described_class.run(options)
        expect(File.exist?(output_path)).to be_true
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end
    end
  end
end
