require "RMagick"

module Photomosaic
  class Image
    def self.create_mosaic_image(image_list, output_path)
      image_list.inject(Magick::ImageList.new) do |images, row|
        images << row.inject(Magick::ImageList.new) do |col_images, image|
          col_images << image.image.dup
          col_images
        end.append(false)

        images
      end.append(true).write(output_path)
    end

    def self.preprocess_image(image_path, width, height, level, colors)
      image = Photomosaic::Image.new(image_path)
      image.resize!(width, height, true)
      image.posterize!(level)
      image.reduce_colors!(colors)
      image
    end

    def self.resize_images(images, width, height)
      images.map do |row|
        row.map { |image| image.resize!(width, height, false) }
      end
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

    def image
      @image
    end

    def posterize!(level)
      @image = @image.posterize(level)
      reload_image
      self
    end

    def reduce_colors!(colors)
      @image = @image.quantize(colors)
      reload_image
      self
    end

    def resize!(width, height, keep_ratio)
      keep_ratio ? @image.resize_to_fit!(width, height) : @image.resize!(width, height)
      reload_image
      self
    end

    private

    def get_characteristic_color(color_model = :rgb)
      color = nil
      original_image = @image.dup

      begin
        resize!(1, 1, false)
        color = pixel_color(1, 1, color_model)
      ensure
        @image = original_image
      end

      color
    end

    def nearest_image(source_image_list, x, y, color_model)
      pixel = pixel_color(x, y, color_model)

      source_image_list.sort_by do |image|
        image.characteristic_color(color_model).calculate_distance(pixel)
      end.first
    end

    def pixel_color(x, y, color_model = :rgb)
      pixel = @image.pixel_color(x, y)
      rgb = Color::RGB.new(pixel.red / 257, pixel.green / 257, pixel.blue / 257)
      color_model == :rgb ? rgb : rgb.to_hsv
    end

    def reload_image
      @image = Magick::Image.from_blob(@image.to_blob).first
    end

    def image_height
      @image.rows
    end

    def image_width
      @image.columns
    end
  end
end
