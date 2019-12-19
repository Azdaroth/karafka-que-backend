# frozen_string_literal: true

RSpec.describe Karafka::Que::Interchanger do
  describe "#encode" do
    subject(:encode) { interchanger.encode(params_batch) }

    let(:interchanger) { described_class.new }
    let(:params_batch) do
      Karafka::Params::ParamsBatch.new(array_params_batch)
    end
    let(:array_params_batch) do
      [
        {
          "value" => 1,
          "deserializer" => "Class",
          "receive_time" => 1,
          "a" => 1
        }
      ]
    end

    it { is_expected.to eq array_params_batch }
  end

  describe "#decode" do
    subject(:decode) { interchanger.decode(params_batch) }

    let(:interchanger) { described_class.new }
    let(:params_batch) do
      Karafka::Params::ParamsBatch.new(array_params_batch)
    end
    let(:array_params_batch) do
      [
        {
          "value" => 1,
          "deserializer" => "Class",
          "receive_time" => 1,
          "a" => 1
        }
      ]
    end

    it { is_expected.to eq params_batch }
  end
end
