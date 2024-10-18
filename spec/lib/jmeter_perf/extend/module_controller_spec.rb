require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  describe "module_controllers" do
    describe "#module_controller" do
      let(:doc) do
        JmeterPerf.test name: "tests" do
          threads 1, name: "threads" do
            simple_controller name: "controller_to_call"
          end
          threads 1 do
            module_controller name: "modules", node_path: [
              "WorkBench",
              "tests",
              "threads",
              "controller_to_call"
            ]
          end
        end.to_doc
      end

      let(:simple_controller) { doc.search("//GenericController").first }
      let(:test_module) { doc.search("//ModuleController").first }
      let(:nodes) { test_module.search(".//stringProp") }

      it "should have a node path" do
        expect(nodes.length).to eq 4
        expect(nodes[0].text).to eq "WorkBench"
        expect(nodes[1].text).to eq "tests"
        expect(nodes[2].text).to eq "threads"
        expect(nodes[3].text).to eq "controller_to_call"
      end

      context "with test fragment" do
        let(:doc) do
          JmeterPerf.test do
            test_fragment name: "some_test_fragment", enabled: "false" do
              get name: "Home Page", url: "http://google.com"
            end

            threads count: 1 do
              module_controller test_fragment: "WorkBench/TestPlan/some_test_fragment"
            end
          end.to_doc
        end

        let(:simple_controller) { doc.search("//GenericController").first }
        let(:test_module) { doc.search("//ModuleController").first }
        let(:nodes) { test_module.search(".//stringProp") }

        it "should have a node path specified by test fragment" do
          expect(nodes.length).to eq 3
          expect(nodes[0].text).to eq "WorkBench"
          expect(nodes[1].text).to eq "TestPlan"
          expect(nodes[2].text).to eq "some_test_fragment"
        end
      end
    end
  end
end
