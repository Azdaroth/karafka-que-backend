# frozen_string_literal: true

module Karafka
  module Que
    module Workers
      class Builder
        attr_reader :consumer_class
        private     :consumer_class

        def initialize(consumer_class)
          @consumer_class = consumer_class
        end

        def build
          return matcher.match if matcher.match

          klass = Class.new(Karafka::BaseQueWorker.base_worker)
          matcher.scope.const_set(matcher.name, klass)
        end

        private

        def matcher
          @matcher ||= Helpers::ClassMatcher.new(consumer_class, from: "Consumer", to: "Worker")
        end
      end
    end
  end
end
