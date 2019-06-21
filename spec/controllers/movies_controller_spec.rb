require "rails_helper"

RSpec.describe MoviesController, type: :controller do
  let(:current_user) { User.first }

  describe "GET send_info" do
    login_user

    let(:mail_double) { double MovieInfoMailer }
    let(:movie) { double Movie, id: 1 }

    before do
      allow(Movie).to receive(:find).with("1").and_return(movie)
    end

    subject { get(:send_info, params: { id: "1" }) }

    it "sends asynchronously email" do
      expect(MovieInfoMailer).to receive(:send_info)
        .with(current_user, movie).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later)

      subject
    end
  end

  describe "GET export" do
    it "runs export job" do
      expect(ExportMoviesJob).to receive(:perform_later).with(current_user)

      get :export
    end

    it "redirects to root" do
      expect(get(:export)).to redirect_to root_url
    end
  end
end
