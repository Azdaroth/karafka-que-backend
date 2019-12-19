# frozen_string_literal: true

require "bundler/setup"

ENV["KARAFKA_ENV"] = "test"
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require "karafka-que-backend"

module Karafka
  class App
    setup do |config|
      config.kafka.seed_brokers = %w[kafka://localhost:9092]
      config.client_id = "client_id"
      config.kafka.offset_retention_time = -1
      config.kafka.max_bytes_per_partition = 1_048_576
      config.kafka.start_from_beginning = true
    end
  end
end

class WhateverItTakesConsumer < Karafka::BaseConsumer
  def consume
    raise if defined?(metadata)
    logger = Logger.new(STDOUT)
    logger.info("WhateverItTakesConsumer: consumed")
    logger.info("params_batch key: #{params_batch.first['payload']['key']}")
  end
end

class WhateverItTakesConsumerWithBatchFetching < Karafka::BaseConsumer
  def consume
    logger = Logger.new(STDOUT)
    logger.info("meta: #{metadata['meta']}")
    logger.info("WhateverItTakesConsumerWithBatchFetching: consumed")
    logger.info("params_batch key: #{params_batch.first['payload']['key']}")
  end
end

Karafka::App.consumer_groups.draw do
  consumer_group :test_group do
    batch_fetching false

    topic :que_topic do
      consumer WhateverItTakesConsumer
    end
  end

  consumer_group :test_group_with_batch_fetching do
    batch_fetching true

    topic :que_topic do
      consumer WhateverItTakesConsumerWithBatchFetching
    end
  end
end

Karafka::App.boot!
