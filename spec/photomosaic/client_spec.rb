require "spec_helper"

module Photomosaic
  describe Client do
    let(:search_engine) do
      SearchEngine::Bing
    end

    let(:api_key) do
      "api_key"
    end

    let(:keyword) do
      "keyword"
    end

    let(:options) do
      {
       api_key: api_key,
       search_engine: search_engine,
       keyword: keyword
      }
    end

    describe "#run" do
      it "should run the program" do
        expect_any_instance_of(SearchEngine::Bing).to receive(:get_image_list).with(keyword).once
        expect_any_instance_of(ImageDownloader).to receive(:download_images).once
        expect_any_instance_of(ImageDownloader).to receive(:remove_save_dir).once
        described_class.run(options)
      end
    end
  end
end
