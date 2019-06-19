require "rails_helper"

describe Movies::Fetcher do
  let(:service_instance) { described_class.new }

  let(:movies) { Movie.all }

  describe "#call" do
    subject { service_instance.call(movies) }

    let(:responses) do
      [
        "{\"data\":{\"id\":\"6\",\"type\":\"movie\",\"attributes\":{\"title\":\"Fake title 1\",
        \"plot\":\"Fake Plot 1\",\"rating\":9.2,\"poster\":\"/aaa.jpg\"}}}",
        "{\"data\":{\"id\":\"6\",\"type\":\"movie\",\"attributes\":{\"title\":\"Fake title 2\",
        \"rating\":8.2,\"poster\":\"/bbb.jpg\"}}}"
      ]
    end

    before do
      create(:movie, title: "Fake title 1")
      create(:movie, title: "Fake title 2")

      stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Fake%20title%201")
        .to_return(status: 200, body: responses[0], headers: {})

      stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Fake%20title%202")
        .to_return(status: 200, body: responses[1], headers: {})
    end

    it { is_expected.to eq(movies) }

    it "appends attributes" do
      aggregate_failures "testing appended attributes" do
        expect(movies.first.plot).to be_nil
        expect(movies.first.poster).to be_nil
        expect(movies.first.rating).to be_nil

        expect(movies.second.plot).to be_nil
        expect(movies.second.poster).to be_nil
        expect(movies.second.rating).to be_nil

        ms = subject

        expect(ms[0].plot).to eq "Fake Plot 1"
        expect(ms[0].poster).to eq "/aaa.jpg"
        expect(ms[0].rating).to eq(9.2)

        expect(ms[1].plot).to be_nil
        expect(ms[1].poster).to eq "/bbb.jpg"
        expect(ms[1].rating).to eq(8.2)
      end
    end

    context "when response has blank body" do
      let(:movies) { [Movie.first] }
      let(:responses) { [""] }

      it "appends attributes" do
        aggregate_failures "testing appended attributes" do
          expect(movies.first.plot).to be_nil
          expect(movies.first.poster).to be_nil
          expect(movies.first.rating).to be_nil

          ms = subject

          expect(ms[0].plot).to be_nil
          expect(ms[0].poster).to be_nil
          expect(ms[0].rating).to be_nil
        end
      end
    end

    context "when request throws an error" do
      before do
        stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Fake%20title%202")
          .to_raise(StandardError)
      end

      it "appends attributes" do
        aggregate_failures "testing appended attributes" do
          expect(movies.first.plot).to be_nil
          expect(movies.first.poster).to be_nil
          expect(movies.first.rating).to be_nil

          expect(movies.second.plot).to be_nil
          expect(movies.second.poster).to be_nil
          expect(movies.second.rating).to be_nil

          ms = subject

          expect(ms[0].plot).to eq "Fake Plot 1"
          expect(ms[0].poster).to eq "/aaa.jpg"
          expect(ms[0].rating).to eq(9.2)

          expect(ms[1].plot).to be_nil
          expect(ms[1].poster).to be_nil
          expect(ms[1].rating).to be_nil
        end
      end
    end
  end
end
