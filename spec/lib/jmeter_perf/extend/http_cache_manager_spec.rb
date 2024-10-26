require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "#http_cache_manager" do
    context "clear_each_iteration option" do
      let(:test_plan) do
        JmeterPerf.test do
          cache clear_each_iteration: true
        end
      end

      let(:cache_fragment) { doc.search("//CacheManager") }

      it "should match on clearEachIteration" do
        expect(cache_fragment.search(".//boolProp[@name='clearEachIteration']").first.text).to eq "true"
      end
    end

    context "use_expires option" do
      let(:test_plan) do
        JmeterPerf.test do
          cache use_expires: true
        end
      end
      let(:cache_fragment) { doc.search("//CacheManager") }
      it "should match on useExpires" do
        expect(cache_fragment.search(".//boolProp[@name='useExpires']").first.text).to eq "true"
      end
    end
  end
end
