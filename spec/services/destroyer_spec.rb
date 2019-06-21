require "rails_helper"

RSpec.describe Comments::Destroyer do
  subject { described_class.new(user, comment.id).call }

  let(:user) { create :user }
  let(:movie) { create :movie }
  let!(:comment) { create :comment, user_id: user.id, movie: movie }

  it "destroy comment" do
    expect { subject }.to change { Comment.count }.by(-1)
  end

  it "returns destroyed comment" do
    expect(subject).to be_instance_of(Comment)
  end

  context "when user try destroy not own comment" do
    let(:comment) { create(:comment, user_id: create(:user).id, movie: movie) }

    it "throws an ActiveRecord::RecordNotFound error" do
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
