# frozen_string_literal: true

module Karafka
  module Que
    class Runner
      def run(topic_id, params_batch, metadata)
        consumer = build_consumer(topic_id, params_batch, metadata)

        Karafka.monitor.instrument("backends.que.runner.run", caller: self, consumer: consumer) do
          consumer.consume
        end
      end

      private

      def build_consumer(topic_id, params_batch, metadata)
        topic = Karafka::Routing::Router.find(topic_id)

        topic.consumer.new(topic).tap do |consumer|
          consumer.params_batch = build_params_batch(topic, params_batch)

          if topic.batch_fetching
            consumer.metadata = build_consumer_metadata(topic, metadata)
          end
        end
      end

      def build_params_batch(topic, params_batch)
        params_array = topic.interchanger.decode(params_batch).map! do |hash|
          Karafka::Params::Params.new.merge!(hash).merge!("deserializer" => topic.deserializer)
        end

        Karafka::Params::ParamsBatch.new(params_array)
      end

      def build_consumer_metadata(topic, metadata)
        Karafka::Params::Metadata
          .new
          .merge!(metadata)
          .merge!("deserializer" => topic.deserializer)
      end
    end
  end
end
