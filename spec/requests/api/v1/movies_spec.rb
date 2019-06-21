require "rails_helper"

describe "api v1 movies requests", type: :request do
  describe "movies list" do
    let!(:movies) do
      [create(:movie, title: "fake title 1"), create(:movie, title: "fake title 2")]
    end

    let(:movies_response) do
      [
        { id: movies.first.id, title: "fake title 1" },
        { id: movies.second.id, title: "fake title 2" }
      ].to_json
    end

    it "render right json" do
      visit "/api/v1/movies"
      expect(page.body).to eq(movies_response)
    end
  end

  describe "movie details" do
    let(:movie) { create :movie, title: "Fake title" }

    it "render right json" do
      visit "/api/v1/movies/#{movie.id}"
      expect(page.body).to eq({ id: movie.id, title: "Fake title" }.to_json)
    end
  end
end
