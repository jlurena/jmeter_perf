RSpec.shared_context "test plan doc" do
  let(:doc) do
    Nokogiri::XML(test_plan.root.to_s, &:noblanks)
  end
end
