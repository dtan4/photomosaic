require "optparse"

module Photomosaic
  class Options
    KEYS = %w(
    api_key
    base_image
    color_model
    colors
    height
    keyword
    output_path
    results
    search_engine
    width
    )

    REQUIRED_KEYS = %w(
    api_key
    base_image
    output_path
    )

    def self.parse(argv)
      options = default_options
      parser(options).parse(argv)
      options[:api_key] = api_key
      check_options(options)

      self.new(options)
    end

    def initialize(options)
      @options = options
    end

    KEYS.each do |key|
      define_method(key) { @options[key.to_sym] }
    end

    private

    def self.api_key
      ENV["PHOTOMOSAIC_API_KEY"]
    end

    def self.check_options(options)
      REQUIRED_KEYS.each do |key|
        raise OptionParser::MissingArgument, key unless options[key.to_sym]
      end
    end

    def self.default_options
      {
       color_model: :rgb,
       colors: 16,
       height: 200,
       results: 50,
       search_engine: Photomosaic::SearchEngine::Bing,
       width: 200,
      }
    end

    def self.parser(options)
      OptionParser.new do |opt|
        opt.on("-b", "--base_image=VAL", "Path of base image") { |val| options[:base_image] = File.expand_path(val) }
        opt.on("-c", "--colors=VAL", "Number of colors") { |val| options[:colors] = val.to_i }
        opt.on("-h", "--height=VAL", "Height of output image") { |val| options[:height] = val.to_i }
        opt.on("-k", "--keyword=VAL", "Keyword") { |val| options[:keyword] = val }
        opt.on("-o", "--output_path=VAL", "Path of mosaic image") { |val| options[:output_path] = File.expand_path(val) }
        opt.on("-r", "--results=VAL", "Number of results") { |val| options[:results] = val.to_i }
        opt.on("-w", "--width=VAL", "Width of output image") { |val| options[:width] = val.to_i }
        opt.on("--hsv", "Use HSV") { |val| options[:color_model] = :hsv }
      end
    end
  end
end
