# frozen_string_literal: true

module Karafka
  module Backends
    module Que
      def process
        Karafka.monitor.instrument("backends.que.process", caller: self) do
          topic.worker.enqueue(
            topic.id,
            topic.interchanger.encode(params_batch),
            respond_to?(:metadata) ? metadata : nil
          )
        end
      end
    end
  end
end
