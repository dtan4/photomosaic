require "fileutils"
require "open-uri"

module Photomosaic
  class ImageDownloader
    def initialize(save_dir = tmp_dir)
      @save_dir = save_dir
    end

    def download_images(image_list)
      image_list.inject([]) do |path_list, image_url|
        image_path = File.join(@save_dir, File.basename(image_url))

        begin
          download_image(image_url, image_path)
          path_list << image_path
        rescue
        end

        path_list
      end
    end

    def remove_save_dir
      FileUtils.remove_entry_secure(@save_dir)
    end

    private

    def download_image(image_url, image_path)
      open(image_path, "wb+") { |f| f.puts open(image_url).read }
    end

    def tmp_dir
      Dir.mktmpdir("photomosaic")
    end
  end
end
