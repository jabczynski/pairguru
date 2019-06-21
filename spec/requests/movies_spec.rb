require "rails_helper"

describe "Movies requests", type: :request do
  let!(:movie) { create :movie, title: "Fake title" }

  let(:response) do
    "{\"data\":{\"id\":\"6\",\"type\":\"movie\",\"attributes\":{\"title\":\"Fake title\",
    \"plot\":\"Fake Plot 1\",\"rating\":9.2,\"poster\":\"/aaa.jpg\"}}}"
  end

  before do
    stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Fake%20title")
      .to_return(status: 200, body: response, headers: {})
  end

  describe "movies list" do
    it "displays right content" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")
      expect(page).to have_css("img[src='https://pairguru-api.herokuapp.com/aaa.jpg']")
      expect(page).to have_selector("p", text: "Fake Plot 1")
      expect(page).to have_selector("p", text: "9.2")
    end
  end

  describe "movie page" do
    it "displays right content" do
      visit "/movies/#{movie.id}"
      expect(page).to have_css("img[src='https://pairguru-api.herokuapp.com/aaa.jpg']")
      expect(page).to have_selector(".jumbotron", text: "Fake Plot 1")
      expect(page).to have_selector("h3", text: "9.2")
    end
  end
end
