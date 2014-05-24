require "spec_helper"
require "fileutils"
require "webmock/rspec"

module Photomosaic
  describe ImageDownloader do
    let(:downloader) do
      described_class.new(tmp_dir)
    end

    describe "#initialize" do
      context "with save directory" do
        it "should set the specified directory to @save_dir" do
          downloader = described_class.new(tmp_dir)
          expect(downloader.instance_variable_get(:@save_dir)).to eq tmp_dir
        end
      end

      context "without save directory" do
        it "should set temporary directory to @save_dir" do
          downloader = described_class.new
          expect(downloader.instance_variable_get(:@save_dir)).to match(/photomosaic/)
        end
      end
    end

    describe "#download_images" do
      let(:image_list) do
        [
         "http://example.com/image01.jpg",
         "http://example.com/image02.jpg",
         "http://example.com/notfound.jpg"
        ]
      end

      before do
        stub_request(:get, %r(http://example\.com/image0\d\.jpg))
          .to_return(status: 200, body: "hoge")
        stub_request(:get, "http://example.com/notfound.jpg")
          .to_return(status: 404)
        FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)
        Dir.mkdir(tmp_dir)
      end

      it "should download listed images to temporary directory" do
        downloader.download_images(image_list)

        %w(image01.jpg image02.jpg).each do |image|
          expect(File.exist?(tmp_path(image))).to be_true
        end
      end

      it "should return the path list" do
        result = downloader.download_images(image_list)
        expect(result).to match_array %w(image01.jpg image02.jpg).map { |image| tmp_path(image) }
      end

      after do
        FileUtils.rm_rf(tmp_dir)
      end
    end

    describe "#remove_save_dir" do
      before do
        Dir.mkdir(tmp_dir)
      end

      it "should remove save directory" do
        downloader.remove_save_dir
        expect(Dir.exist?(tmp_dir)).to be_false
      end
    end
  end
end
