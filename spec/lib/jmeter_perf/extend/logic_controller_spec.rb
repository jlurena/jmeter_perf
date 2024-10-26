require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "logic_controller" do
    describe "disabled elements" do
      let(:test_plan) do
        JmeterPerf.test do
          header name: "Accept", value: "*", enabled: false
        end
      end

      let(:fragment) { doc.search("//HeaderManager") }

      it "should be disabled" do
        expect(fragment.first.attributes["enabled"].value).to eq "false"
      end
    end

    describe "#if_controller" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            if_controller condition: "2>1" do
              visit url: "/"
            end
          end
        end
      end

      let(:fragment) { doc.search("//IfController").first }

      it "should match on if_controller" do
        expect(fragment.search(".//stringProp[@name='IfController.condition']").text).to eq "2>1"
      end
    end

    describe "#exists" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            exists "apple" do
              visit url: "/"
            end
          end
        end
      end

      let(:fragment) { doc.search("//IfController").first }

      it "should match on exists" do
        expect(fragment.search(".//stringProp[@name='IfController.condition']").text).to eq '"${apple}" != "\${apple}"'
      end
    end

    describe "#while_controller" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            while_controller condition: "true" do
              visit url: "/"
            end
          end
        end
      end

      let(:fragment) { doc.search("//WhileController").first }

      it "should match on while_controller" do
        expect(fragment.search(".//stringProp[@name='WhileController.condition']").text).to eq "true"
      end
    end

    describe "#counter" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            visit url: "/" do
              counter start: 1, per_user: true
            end
          end
        end
      end

      let(:fragment) { doc.search("//CounterConfig").first }

      it "should match on 5 Loops" do
        expect(fragment.search(".//boolProp[@name='CounterConfig.per_user']").text).to eq "true"
      end
    end

    describe "#switch_controller" do
      let(:test_plan) do
        JmeterPerf.test do
          threads do
            switch_controller value: "cat" do
              visit url: "/"
            end
          end
        end
      end

      let(:fragment) { doc.search("//SwitchController").first }

      it "should match on switch_controller" do
        expect(fragment.search(".//stringProp[@name='SwitchController.value']").text).to eq "cat"
      end
    end

    context "Nested controllers" do
      let(:test_plan) do
        JmeterPerf.test do
          simple_controller name: "node1.1" do
            simple_controller name: "node2.1"
            simple_controller name: "node2.2" do
              simple_controller name: "node3.1"
            end
            simple_controller name: "node2.3"
          end
          simple_controller name: "node1.2"
        end
      end

      let(:node1_1) { doc.search("//GenericController[@testname='node1.1']").first }
      let(:node1_2) { doc.search("//GenericController[@testname='node1.2']").first }

      let(:node2_1) { doc.search("//GenericController[@testname='node2.1']").first }
      let(:node2_2) { doc.search("//GenericController[@testname='node2.2']").first }
      let(:node2_3) { doc.search("//GenericController[@testname='node2.3']").first }

      let(:node3_1) { doc.search("//GenericController[@testname='node3.1']").first }

      it "nodes should have hashTree as its parent" do
        [node1_1, node1_2, node2_1, node2_2, node2_3, node3_1].each do |node|
          expect(node.parent.name).to eq "hashTree"
        end
      end

      context "node3_1" do
        it "parent parent should be node2_2" do
          expect(node3_1.parent).to eq node2_2.next
        end
      end

      context "node1_2" do
        it "previous non hashTree sibling is node1_1" do
          expect(node1_2.previous.previous).to eq node1_1
        end
      end
    end
  end
end
