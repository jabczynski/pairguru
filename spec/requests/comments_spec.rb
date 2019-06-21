require "rails_helper"

describe "Comments requests", type: :request do
  let(:movie) { create :movie }
  let(:user) { create :user }
  let!(:comment) { create :comment, user_id: user.id, movie: movie, content: "fake content" }

  describe "add the comment" do
    let(:current_user) { create :user }

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
    it "displays all comments" do
      sign_in(user)

      visit "/movies/#{movie.id}"

      expect(page).to have_selector("p", text: "Content: fake content")

      click_link("Delete comment")

      expect(page).not_to have_selector("p", text: "Content: fake content")
    end
  end
end
