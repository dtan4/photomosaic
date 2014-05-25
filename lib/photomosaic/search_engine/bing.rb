require "searchbing"

module Photomosaic::SearchEngine
  RESULTS_COUNT = 10

  class Bing
    def initialize(api_key)
      @client = ::Bing.new(api_key, RESULTS_COUNT, "Image")
    end

    def get_image_list(keyword)
      @client.search(keyword)[0][:Image].map { |image| image[:MediaUrl] }
    end
  end
end
