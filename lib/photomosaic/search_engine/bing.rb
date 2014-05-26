require "searchbing"

module Photomosaic
  module SearchEngine
    class Bing
      def initialize(api_key, number_results)
        @client = ::Bing.new(api_key, number_results, "Image")
      end

      def get_image_list(keyword)
        @client.search(keyword)[0][:Image].map { |image| image[:MediaUrl] }
      end
    end
  end
end
