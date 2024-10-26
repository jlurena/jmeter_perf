require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "loop_controller" do
    describe "#loops" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            loops count: 5 do
              visit url: "/"
            end
          end
        end
      end

      let(:fragment) { doc.search("//LoopController").first }

      it "should match on Loops" do
        expect(fragment.search(".//stringProp[@name='LoopController.loops']").text).to eq "5"
      end
    end
  end
end
