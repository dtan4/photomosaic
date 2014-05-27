require "spec_helper"

module Photomosaic
  describe Options do
    let(:api_key) { "api_key" }
    let(:base_image_path) { "base_image_path" }
    let(:colors) { 16 }
    let(:height) { 10 }
    let(:width) { 20 }
    let(:results) { 100 }
    let(:keyword) { "keyword" }
    let(:output_path) { "output_path" }

    let(:argv) do
      "#{base_image_path} #{output_path} -k #{keyword} -c #{colors} -h #{height} -w #{width} -r #{results}".split(" ")
    end

    describe "#parse" do
      before do
        allow(ENV).to receive(:[]).with("PHOTOMOSAIC_API_KEY").and_return(api_key)
      end

      it "should return Options instance" do
        expect(described_class.parse(argv)).to be_a described_class
      end

      it "should parse option string" do
        options = described_class.parse(argv)
        expect(options.api_key).to eq api_key
        expect(options.base_image).to eq File.expand_path(base_image_path)
        expect(options.color_model).to eq :rgb
        expect(options.colors).to eq colors
        expect(options.height).to eq height
        expect(options.keyword).to eq keyword
        expect(options.output_path).to eq File.expand_path(output_path)
        expect(options.results).to eq results
        expect(options.search_engine).to eq Photomosaic::SearchEngine::Bing
        expect(options.width).to eq width
      end
    end
  end
end
