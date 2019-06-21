require "rails_helper"

describe "api v2 movies requests", type: :request do
  let(:genre) { create(:genre, name: "fake genre") }
  let(:genre_response) { { id: genre.id, name: "fake genre", movies_count: movies_count } }
  let(:movies_count) { 2 }

  describe "movies list" do
    let!(:movies) do
      [
        create(:movie, title: "fake title 1", genre: genre),
        create(:movie, title: "fake title 2", genre: genre)
      ]
    end

    let(:movies_response) do
      [
        { id: movies.first.id, title: "fake title 1", genre: genre_response },
        { id: movies.second.id, title: "fake title 2", genre: genre_response }
      ].to_json
    end

    it "render right json" do
      visit "/api/v2/movies"
      expect(page.body).to eq(movies_response)
    end
  end

  describe "movie details" do
    let(:movie) { create :movie, title: "Fake title", genre: genre }
    let(:movies_count) { 1 }

    it "render right json" do
      visit "/api/v2/movies/#{movie.id}"
      expect(page.body).to eq({ id: movie.id, title: "Fake title", genre: genre_response }.to_json)
    end
  end
end
