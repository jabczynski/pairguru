require "rails_helper"

RSpec.describe ExportMoviesJob, type: :job do
  let(:current_user) { create :user }

  describe "#perform_later" do
    it "enqueue the job" do
      ActiveJob::Base.queue_adapter = :test
      expect { described_class.perform_later(current_user) }
        .to have_enqueued_job.with(current_user).on_queue("default")
    end

    it "runs a MovieExporter service" do
      expect_any_instance_of(MovieExporter).to receive(:call).with(current_user, "tmp/movies.csv")

      described_class.perform_now(current_user)
    end
  end
end
