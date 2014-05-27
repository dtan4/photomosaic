require "optparse"
require "ostruct"

module Photomosaic
  class Options < OpenStruct
    def self.parse(argv)
      options = default_options
      argv = parser(options).parse(argv)

      options[:base_image] = File.expand_path(argv[0])
      options[:output] = File.expand_path(argv[1])
      options[:keyword] = argv[2]
      options[:api_key] = ENV["PHOTOMOSAIC_API_KEY"]

      self.new(options)
    end

    def initialize(options_hash)
      super(options_hash)
    end

    private

    def self.default_options
      {
       color_model: :rgb,
       height: 200,
       number_colors: 16,
       number_results: 50,
       search_engine: Photomosaic::SearchEngine::Bing,
       width: 200,
      }
    end

    def self.parser(options)
      OptionParser.new do |opt|
        opt.on("-c", "--colors=VAL", "Number of colors") { |val| options[:colors] = val.to_i }
        opt.on("-h", "--height=VAL", "Height of output image") { |val| options[:height] = val.to_i }
        opt.on("-r", "--results=VAL", "Number of results") { |val| options[:results] = val.to_i }
        opt.on("-w", "--width=VAL", "Width of output image") { |val| options[:width] = val.to_i }
        opt.on("--hsv", "Use HSV") { |val| options[:color_model] = :hsv }
      end
    end
  end
end
