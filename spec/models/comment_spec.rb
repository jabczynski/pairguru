require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it do
      should belong_to(:author).class_name("User")
        .with_foreign_key(:user_id).inverse_of(:comments)
    end

    it { should belong_to(:movie) }
  end
end
