module Photomosaic
  class Client
    def self.run(options)
      search_engine = options[:search_engine].new(options[:api_key])
      image_url_list = search_engine.get_image_list(options[:keyword])
      image_downloader = ImageDownloader.new

      begin
        image_path_list = image_downloader.download_images(image_url_list)
      ensure
        image_downloader.remove_save_dir
      end
    end
  end
end
