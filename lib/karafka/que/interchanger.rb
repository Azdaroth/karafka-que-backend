# frozen_string_literal: true

module Karafka
  module Que
    class Interchanger
      def encode(params_batch)
        params_batch.to_a
      end

      def decode(params_batch)
        params_batch
      end
    end
  end
end
