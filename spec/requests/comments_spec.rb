require "rails_helper"

describe "Comments requests", type: :request do
  let(:movie) { create :movie }
  let(:user) { create :user }

  describe "add the comment" do
    let(:current_user) { create :user }
    let!(:comment) { create :comment, user_id: user.id, movie: movie, content: "fake content" }

    it "displays all comments" do
      sign_in(current_user)

      visit "/movies/#{movie.id}"

      expect(page).to have_selector("p", text: "Content: fake content")

      fill_in "comment_content", with: "new comment content"

      click_button("Save Comment")

      expect(page).to have_selector("p", text: "Content: fake content")
      expect(page).to have_selector("p", text: "Content: new comment content")
    end
  end

  describe "delete the comment" do
    let!(:comment) { create :comment, user_id: user.id, movie: movie, content: "fake content" }

    it "displays all comments" do
      sign_in(user)

      visit "/movies/#{movie.id}"

      expect(page).to have_selector("p", text: "Content: fake content")

      click_link("Delete comment")

      expect(page).not_to have_selector("p", text: "Content: fake content")
    end
  end

  describe "display top users" do
    let(:movies) { Movie.all }
    let(:users) { User.all }

    before do
      create :user, email: "first@example.com"
      create :user, email: "second@example.com"
      create :user, email: "third@example.com"
      create :user, email: "fourth@example.com"
      create_list :movie, 5

      create :comment, movie_id: movies[0].id, user_id: users[0].id
      create :comment, movie_id: movies[0].id, user_id: users[1].id
      create :comment, movie_id: movies[0].id, user_id: users[2].id

      create :comment, movie_id: movies[1].id, user_id: users[1].id
      create :comment, movie_id: movies[2].id, user_id: users[1].id
      create :comment, movie_id: movies[3].id, user_id: users[1].id

      create :comment, movie_id: movies[4].id, user_id: users[2].id
    end

    it "displays top users" do
      visit "/top_users"

      expect(page).to have_selector("p", text: "1. second@example.com 4")
      expect(page).to have_selector("p", text: "2. third@example.com 2")
      expect(page).to have_selector("p", text: "3. first@example.com 1")
    end
  end
end
