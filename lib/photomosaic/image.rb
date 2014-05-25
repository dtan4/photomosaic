require "RMagick"

module Photomosaic
  class Image
    def self.create_tiled_image(image_path_list, rows, columns, output_path)
      image_path_list.each_slice(columns).inject(Magick::ImageList.new) do |image_list, row|
        image_list << Magick::ImageList.new(*row).append(false)
      end.append(true).write(output_path)
    end

    def self.preprocess_image(image_path)
      image = Photomosaic::Image.new(image_path)
      image.resize!(50, 50)
      image.posterize!
      image.reduce_colors!
      image
    end

    def initialize(image_path)
      @image = Magick::Image.read(image_path).first
    end

    def characteristic_color(color_model = :rgb)
      @characteristic_color ||= get_characteristic_color(color_model)
    end

    def dispatch_images(source_image_list, row_step = 1, col_step = 1, color_model = :rgb)
      (1..image_height).step(row_step).inject([]) do |images, y|
        images << (1..image_width).step(col_step).inject([]) do |col_images, x|
          col_images << nearest_image(source_image_list, x, y, color_model)
          col_images
        end

        images
      end
    end

    def posterize!(levels = 4)
      @image = @image.posterize(levels = 4)
    end

    def reduce_colors!(number_colors = 8)
      @image = @image.quantize(8)
    end

    def resize!(width, height)
      @image.resize!(width, height)
    end

    private

    def get_characteristic_color(color_model = :rgb)
      color = nil
      original_image = @image

      begin
        resize!(1, 1)
        color = pixel_color(1, 1, color_model)
      ensure
        @image = original_image
      end

      color
    end

    def nearest_image(source_image_list, x, y, color_model)
      source_image_list.sort_by do |image|
        image.characteristic_color(color_model).calculate_distance(pixel_color(x, y, color_model))
      end.first
    end

    def pixel_color(x, y, color_model = :rgb)
      pixel = @image.pixel_color(x, y)
      rgb = Color::RGB.new(pixel.red / 257, pixel.green / 257, pixel.blue / 257)
      color_model == :rgb ? rgb : rgb.to_hsv
    end

    def image_height
      @image.rows
    end

    def image_width
      @image.columns
    end
  end
end
