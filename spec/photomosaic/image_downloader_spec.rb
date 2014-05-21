require "spec_helper"
require "fileutils"
require "webmock/rspec"

module Photomosaic
  describe ImageDownloader do
    let(:tmpdir) do
      File.expand_path("../tmp", File.dirname(__FILE__))
    end

    let(:downloader) do
      described_class.new(tmpdir)
    end

    describe "#initialize" do
      context "with save directory" do
        it "should set the specified directory to @save_dir" do
          downloader = described_class.new(tmpdir)
          expect(downloader.instance_variable_get(:@save_dir)).to eq tmpdir
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
        Dir.mkdir(tmpdir)
      end

      it "should download listed images to temporary directory" do
        downloader.download_images(image_list)

        %w(image01.jpg image02.jpg).each do |image|
          expect(File.exist?(File.join(tmpdir, image))).to be_true
        end
      end

      it "should return the path list" do
        result = downloader.download_images(image_list)
        expect(result).to match_array %w(image01.jpg image02.jpg).map { |image| File.join(tmpdir, image) }
      end

      after do
        FileUtils.rm_rf(tmpdir)
      end
    end

    describe "#remove_save_dir" do
      before do
        Dir.mkdir(tmpdir)
      end

      it "should remove save directory" do
        downloader.remove_save_dir
        expect(Dir.exist?(tmpdir)).to be_false
      end
    end
  end
end
