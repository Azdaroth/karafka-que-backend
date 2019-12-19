# frozen_string_literal: true

RSpec.describe Karafka::Que::Workers::Builder do
  describe "#build" do
    subject(:build) { builder.build }

    let!(:builder) { described_class.new(FakeForTestingWorkersBuilderConsumer) }
    let!(:base_worker) { Class.new(Karafka::BaseQueWorker) }

    class FakeForTestingWorkersBuilderConsumer
    end

    after do
      if Object.const_defined?(:FakeForTestingWorkersBuilderWorker)
        Object.__send__(:remove_const, :FakeForTestingWorkersBuilderWorker)
      end
      Karafka::BaseQueWorker.instance_variable_set(:@inherited, nil)
    end

    context "when the worker class already exists" do
      before do
        class FakeForTestingWorkersBuilderWorker
        end

        FakeForTestingWorkersBuilderWorker
      end

      it "returns existing worker class for that consumer" do
        expect(Karafka::BaseQueWorker).not_to receive(:base_worker)

        expect(build.to_s).to eq "FakeForTestingWorkersBuilderWorker"
        expect(build).not_to be < base_worker
        expect(Object.const_defined?(:FakeForTestingWorkersBuilderWorker)).to eq true
      end
    end

    context "when the worker class does not exist" do
      before do
        if Object.const_defined?(:FakeForTestingWorkersBuilderWorker)
          Object.__send__(:remove_const, :FakeForTestingWorkersBuilderWorker)
        end
      end

      it "builds a new worker class for that consumer" do
        expect(Karafka::BaseQueWorker).to receive(:base_worker).and_call_original

        expect(build.to_s).to eq "FakeForTestingWorkersBuilderWorker"
        expect(build).to be < base_worker
        expect(Object.const_defined?(:FakeForTestingWorkersBuilderWorker)).to eq true
      end
    end
  end
end
