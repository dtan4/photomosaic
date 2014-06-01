module Photomosaic
  class Client
    def initialize(argv)
      @options = Photomosaic::Options.parse(argv)
    end

    def execute
      @image_downloader = Photomosaic::ImageDownloader.new

      begin
        resized_images = Photomosaic::Image.resize_images(pixel_images, 40, 20)
        Photomosaic::Image.create_mosaic_image(resized_images, @options.output_path)
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
                                                          @options.level,
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
        rescue Magick::ImageMagickError
          nil
        end
      end.compact
    end

    def pixel_images
      @pixel_images ||=
        base_image.dispatch_images(image_list, 1, 2, @options.color_model)
    end

    def search_engine
      @options.search_engine.new(@options.api_key, @options.results)
    end
  end
end
