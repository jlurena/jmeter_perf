require "spec_helper"

RSpec.describe "pass_performance_test matcher" do
  let(:comparator) { instance_double(JmeterPerf::Report::Comparator) }

  before do
    allow(comparator).to receive(:is_a?).with(JmeterPerf::Report::Comparator).and_return(true)
  end

  context "when the comparator meets performance criteria" do
    before do
      allow(comparator).to receive(:pass?).and_return(true)
    end

    it "passes the performance test" do
      expect(comparator).to pass_performance_test
    end

    it "passes with a specified effect size" do
      expect(comparator).to pass_performance_test.with_effect_size(:small)
    end

    it "passes with a specific Cohen's d limit" do
      expect(comparator).to pass_performance_test.with_cohen_d_limit(0.2)
    end

    it "passes with multiple options" do
      expect(comparator).to pass_performance_test.with(effect_size: :small, cohen_limit: 0.2)
    end
  end

  context "when the comparator does not meet performance criteria" do
    before do
      allow(comparator).to receive(:pass?).and_return(false)
    end

    it "fails the performance test" do
      expect(comparator).not_to pass_performance_test
    end

    it "fails with an incorrect effect size" do
      expect(comparator).not_to pass_performance_test.with_effect_size(:large)
    end

    it "fails with a too-low Cohen's d limit" do
      expect(comparator).not_to pass_performance_test.with_cohen_d_limit(0.1)
    end
  end

  context "when a non-comparator object is tested" do
    it "fails and shows an error message for an invalid object" do
      expect { expect("not a comparator").to pass_performance_test }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /String is not a valid comparator/)
    end
  end
end
