require "spec_helper"
require "json"
require "webmock/rspec"

module Photomosaic
  module SearchEngine
    describe Bing do
      let(:api_key) do
        "api_key"
      end

      let(:search_keyword) do
        "keyword"
      end

      let(:results) do
        30
      end

      let(:client) do
        described_class.new(api_key, results)
      end

      describe "#get_image_list" do
        before do
          stub_request(
                       :get,
                       "https://:#{api_key}@api.datamarket.azure.com/Bing/Search/v1/Composite?$format=json&$skip=0&$top=#{results}&Query='#{search_keyword}'&Sources='Image'"
                      )
            .to_return(
                       status: 200,
                       body: JSON.generate(
                                           d: {
                                               results: [
                                                         {
                                                          Image: [
                                                                  { MediaUrl: "http://example.com/image01.jpg" },
                                                                  { MediaUrl: "http://example.com/image02.jpg" }
                                                                 ]
                                                         }
                                                        ]
                                              }
                                          )
                      )
        end

        it "should return image list" do
          expect(client.get_image_list(search_keyword))
            .to match_array [
                             "http://example.com/image01.jpg",
                             "http://example.com/image02.jpg"
                            ]
        end
      end
    end
  end
end
