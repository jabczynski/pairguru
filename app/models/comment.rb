class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :author, class_name: "User", foreign_key: :user_id, inverse_of: :comments

  validates :movie_id, uniqueness: { scope: :user_id }
end
