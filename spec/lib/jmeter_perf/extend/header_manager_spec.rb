require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "#header_manager" do
    let(:test_plan) do
      JmeterPerf.test do
        header name: "Accept", value: "*"
      end
    end

    let(:fragment) { doc.search("//HeaderManager").first }

    it "should match on accept" do
      expect(fragment.search(".//stringProp[@name='Header.name']").text).to eq "Accept"
      expect(fragment.search(".//stringProp[@name='Header.value']").text).to eq "*"
    end
  end

  describe "header manager multiple values" do
    let(:test_plan) do
      JmeterPerf.test do
        header [{name: "Accept", value: "1"}, {name: "Accept", value: "2"}]
      end
    end

    let(:fragment) { doc.search("//HeaderManager") }

    it "should match on accept for fragment_first" do
      expect(fragment.search(".//stringProp[@name='Header.name']").first.text).to eq "Accept"
      expect(fragment.search(".//stringProp[@name='Header.value']").first.text).to eq "1"
    end

    it "should match on accept for fragment_last" do
      expect(fragment.search(".//stringProp[@name='Header.name']").last.text).to eq "Accept"
      expect(fragment.search(".//stringProp[@name='Header.value']").last.text).to eq "2"
    end
  end
end
