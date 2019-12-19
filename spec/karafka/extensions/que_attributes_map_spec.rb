# frozen_string_literal: true

RSpec.describe Karafka::Extensions::QueAttributesMap do
  describe "#topic" do
    subject(:topic) { attributes_map.topic }

    let(:attributes_map) { Karafka::AttributesMap }

    it { is_expected.to include :interchanger }
    it { is_expected.to include :worker }
  end
end
