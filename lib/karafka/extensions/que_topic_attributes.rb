# frozen_string_literal: true

module Karafka
  module Extensions
    module QueTopicAttributes
      def worker
        @worker ||= begin
          return nil if backend != :que
          Karafka::Que::Workers::Builder.new(consumer).build
        end
      end

      def interchanger
        @interchanger ||= Karafka::Que::Interchanger.new
      end

      def self.included(base)
        base.send(:attr_writer, :worker)
        base.send(:attr_writer, :interchanger)
      end
    end
  end
end
