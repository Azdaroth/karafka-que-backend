# frozen_string_literal: true

RSpec.describe Karafka::BaseQueWorker do
  describe "#run" do
    subject(:run) { que_worker.run(topic_id, params_batch, metadata) }
    
    let(:que_worker) { described_class.new({}) }

    let(:topic_id) { "topic" }
    let(:params_batch) { double(:params_batch) }
    let(:metadata ) { double(:metadata) }

    it "calls Karafka::Que::Runner and destroys the job" do
      expect_any_instance_of(Karafka::Que::Runner).to receive(:run).with(topic_id, params_batch, metadata)
      expect(que_worker).to receive(:destroy)

      run
    end
  end
end
