module Photomosaic
  class Client
    def self.execute(argv)
      options = Photomosaic::Options.parse(argv)
      search_engine = options.search_engine.new(options.api_key, options.results)
      image_url_list = search_engine.get_image_list(options.keyword)
      base_image = Photomosaic::Image.preprocess_image(options.base_image, options.width, options.height, 4, options.number_colors)
      image_downloader = Photomosaic::ImageDownloader.new

      begin
        image_path_list = image_downloader.download_images(image_url_list)
        image_list = get_image_list(image_path_list)
        images = base_image.dispatch_images(image_list, 1, 2, options.color_model)
        resize_to_pixel(images)
        Photomosaic::Image.create_mosaic_image(images, options.output_path)
      ensure
        image_downloader.remove_save_dir
      end
    end

    private

    def self.get_image_list(image_path_list)
      image_path_list.map do |path|
        begin
          Photomosaic::Image.new(path)
        rescue
          nil
        end
      end.compact
    end

    def self.resize_to_pixel(images)
      images.map! do |row|
        row.map {|image| image.resize!(40, 20, false); image }
      end
    end
  end
end
