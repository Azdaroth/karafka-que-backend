# frozen_string_literal: true

%w[
  karafka
  que
].each(&method(:require))

Zeitwerk::Loader
  .for_gem
  .tap { |loader| loader.ignore("#{__dir__}/karafka_que_backend.rb") }
  .tap { |loader| loader.ignore("#{__dir__}/karafka-que-backend.rb") }
  .tap(&:setup)
  .tap(&:eager_load)


Karafka::Routing::Topic.include(Karafka::Extensions::QueTopicAttributes)
Karafka::AttributesMap.prepend(Karafka::Extensions::QueAttributesMap)

# Register internal events for instrumentation
%w[
  backends.que.process
  backends.que.base_que_worker.run
].each(&Karafka.monitor.method(:register_event))
