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

    describe "#download_images" do
      let(:image_list) do
        [
         "http://example.com/image01.jpg",
         "http://example.com/image02.jpg"
        ]
      end

      before do
        stub_request(:get, %r(http://example\.com/image0\d\.jpg))
          .to_return(status: 200, body: "hoge")
        Dir.mkdir(tmpdir)
      end

      it "should download listed images to temporary directory" do
        downloader.download_images(image_list)

        image_list.each do |image|
          expect(File.exist?(File.join(tmpdir, File.basename(image)))).to be_true
        end
      end

      it "should return the path list" do
        result = downloader.download_images(image_list)
        expect(result).to match_array image_list.map { |image| File.join(tmpdir, File.basename(image)) }
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
