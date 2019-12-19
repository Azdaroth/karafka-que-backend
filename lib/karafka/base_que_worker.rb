# frozen_string_literal: true

module Karafka
  class BaseQueWorker < ::Que::Job
    def self.base_worker
      @inherited or raise "missing descentant"
    end

    def self.inherited(subclass)
      @inherited ||= subclass
    end

    def run(topic_id, params_batch, metadata)
      runner.run(topic_id, params_batch, metadata)

      destroy
    end

    private

    def runner
      @runner ||= Karafka::Que::Runner.new
    end
  end
end
