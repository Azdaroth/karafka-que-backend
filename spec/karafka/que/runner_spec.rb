# frozen_string_literal: true

RSpec.describe Karafka::Que::Runner do
  describe "#run" do
    subject(:run) { runner.run(topic_id, params_batch, metadata) }

    let(:runner) { described_class.new }

    let(:params_batch) do
      [
        {
          "payload" => { "key" => "value" }.to_json
        }
      ]
    end
    let(:metadata) do
      {
        "meta" => "data"
      }
    end

    context "when batch fetching is enabled" do
      let(:topic_id) { "client_id_test_group_with_batch_fetching_que_topic" }

      it "infers the consumers and lets it handle the logic with matadata being available" do
        expect_any_instance_of(Logger).to receive(:info).with("meta: data")
        expect_any_instance_of(Logger).to receive(:info).with("WhateverItTakesConsumerWithBatchFetching: consumed")
        expect_any_instance_of(Logger).to receive(:info).with("params_batch key: value")

        expect {
          run
        }.not_to raise_error
      end

      it "uses interchanger" do
        expect_any_instance_of(Karafka::Que::Interchanger).to receive(:decode).and_call_original

        run
      end
    end

    context "when batch fetching is not enabled" do
      let(:topic_id) { "client_id_test_group_que_topic" }

      it "infers the consumers and lets it handle the logic" do
        expect_any_instance_of(Logger).to receive(:info).with("WhateverItTakesConsumer: consumed")
        expect_any_instance_of(Logger).to receive(:info).with("params_batch key: value")

        expect {
          run
        }.not_to raise_error
      end

      it "uses interchanger" do
        expect_any_instance_of(Karafka::Que::Interchanger).to receive(:decode).and_call_original

        run
      end
    end
  end
end
