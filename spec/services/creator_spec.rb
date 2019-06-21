require "rails_helper"

RSpec.describe Comments::Creator do
  subject { described_class.new(user, movie.id).call(comment_content) }

  let(:user) { create :user }
  let(:movie) { create :movie }
  let(:comment_content) { "fake content" }

  it "returns a commment" do
    expect(subject).to be_instance_of(Comment)
  end

  context "when author has not commented the movie" do
    it "creates the comment" do
      expect { subject }.to change { Comment.count }.by(1)
      expect(Comment.last.content).to eq("fake content")
    end

    context "when comment is too long" do
      let(:comment_content) { Faker::Lorem.characters(256) }

      it "return comment with error" do
        expect(subject.errors.messages).to eq(content: ["is too long (maximum is 255 characters)"])
      end
    end

    context "when comment is blank" do
      let(:comment_content) { "  " }

      it "return comment with error" do
        expect(subject.errors.messages).to eq(content: ["can't be blank"])
      end
    end
  end

  context "when author has commented the movie" do
    before { create :comment, movie: movie, user_id: user.id }

    it "return comment with error" do
      expect(subject.errors.messages).to eq(movie_id: ["already commented"])
    end
  end
end
