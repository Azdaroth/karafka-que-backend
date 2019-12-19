# frozen_string_literal: true

RSpec.describe Karafka::Extensions::QueTopicAttributes do
  let(:topic) { Karafka::Routing::Topic.new(name, consumer_group) }
  let(:consumer_group) { instance_double(Karafka::Routing::ConsumerGroup, id: group_id) }
  let(:name) { :test }
  let(:group_id) { "group_id" }
  let(:consumer) { Class.new(Karafka::BaseConsumer) }

  before do
    topic.consumer = consumer
    topic.backend = :inline
  end

  describe "#worker" do
    subject(:worker) { topic.worker }

    before do
      topic.consumer = consumer
      topic.backend = backend
    end

    context "when backend is inline" do
      let(:backend) { :inline }

      it { is_expected.to eq nil }
    end

    context "when backend is que" do
      let(:backend) { :que }

      context "when worker is not set" do
        let!(:base_worker) { Class.new(Karafka::BaseQueWorker) }

        after do
          worker_class_symbol = "#{consumer.class.to_s}Worker".to_sym
          if Object.const_defined?(worker_class_symbol)
            Object.__send__(:remove_const, worker_class_symbol)
          end
          Karafka::BaseQueWorker.instance_variable_set(:@inherited, nil)
        end

        it "uses Karafka::Que::Workers::Builder to build a new worker" do
          expect(worker).to be < Karafka::BaseQueWorker
        end
      end

      context "when worker is set" do
        before do
          topic.worker = worker
        end

        let(:worker) { double }

        it { is_expected.to eq worker }
      end
    end
  end

  describe "#interchanger" do
    subject(:interchanger) { topic.interchanger }

    context "when interchanger is not set" do
      it { is_expected.to be_instance_of Karafka::Que::Interchanger }
    end

    context "when interchanger is set" do
      let(:current_interchanger) { double }

      before do
        topic.interchanger = current_interchanger
      end

      it { is_expected.to eq current_interchanger }
    end
  end

  describe "#to_h" do
    subject(:to_h) { topic.to_h }

    it "contains worker and interchanger" do
      expect(to_h.keys).to include :worker
      expect(to_h.keys).to include :interchanger
    end
  end
end
