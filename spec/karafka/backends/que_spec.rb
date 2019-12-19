# frozen_string_literal: true

RSpec.describe Karafka::Backends::Que do
  describe "#process" do
    subject(:process) { consumer.process }

    let(:consumer) { consumer_class.new(topic) }
    let(:consumer_class) { Class.new(Karafka::BaseConsumer) }
    let(:interchanger) { Karafka::Que::Interchanger.new }
    let(:interchanged_data) { params_batch }
    let(:worker) { Class.new(Karafka::BaseQueWorker) }
    let(:topic) do
      instance_double(
          Karafka::Routing::Topic,
          id: rand.to_s,
          interchanger: interchanger,
          backend: :que,
          batch_consuming: true,
          batch_fetching: false,
          responder: nil,
          deserializer: nil,
          worker: worker
      )
    end
    let(:params_batch) { Karafka::Params::ParamsBatch.new(data) }
    let(:data) do
      [
        {
          "value" => 1,
          "deserializer" => "Class",
          "receive_time" => 1,
          "a" => 1
        }
      ]
    end

    before do
      consumer_class.include(described_class)
      consumer.params_batch = params_batch

      allow(worker).to receive(:enqueue)
    end

    context "when metadata is available" do
      before do
        consumer.instance_eval do
          def metadata
            "__metadata__"
          end
        end
      end

      it "enqueues the job with the encoded data and metadata" do
        process

        expect(worker).to have_received(:enqueue).with(topic.id, data, "__metadata__")
      end
    end

    context "when metadata is not available" do
      it "enqueues the job with the encoded data" do
        process

        expect(worker).to have_received(:enqueue).with(topic.id, data, nil)
      end
    end
  end
end
