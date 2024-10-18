require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  describe "loop_controller" do
    describe "#loops" do
      let(:doc) do
        JmeterPerf.test do
          threads do
            loops count: 5 do
              visit url: "/"
            end
          end
        end.to_doc
      end

      let(:fragment) { doc.search("//LoopController").first }

      it "should match on Loops" do
        expect(fragment.search(".//stringProp[@name='LoopController.loops']").text).to eq "5"
      end
    end
  end
end
