module Photomosaic
  class Client
    def self.execute(argv)
      self.new(argv).execute
    end

    def initialize(argv)
      @options = Photomosaic::Options.parse(argv)
    end

    def execute
      @image_downloader = Photomosaic::ImageDownloader.new

      begin
        resize_to_pixel_size(pixel_images)
        Photomosaic::Image.create_mosaic_image(pixel_images, @options.output_path)
      ensure
        @image_downloader.remove_save_dir
      end
    end

    private

    def base_image
      @base_image ||= Photomosaic::Image.preprocess_image(
                                                          @options.base_image,
                                                          @options.width,
                                                          @options.height,
                                                          4,
                                                          @options.colors
                                                         )
    end

    def image_path_list
      @image_path_list ||= @image_downloader.download_images(image_url_list)
    end

    def image_url_list
      @image_url_list ||= search_engine.get_image_list(@options.keyword)
    end

    def image_list
      @image_list ||= image_path_list.map do |path|
        begin
          Photomosaic::Image.new(path)
        rescue
          nil
        end
      end.compact
    end

    def pixel_images
      @pixel_images ||=
        base_image.dispatch_images(image_list, 1, 2, @options.color_model)
    end

    def resize_to_pixel_size(images)
      images.map! do |row|
        row.map { |image| image.resize!(40, 20, false) }
      end
    end

    def search_engine
      @options.search_engine.new(@options.api_key, @options.results)
    end
  end
end
