class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]
  before_action :set_movie, only: [:show, :send_info]

  def index
    @movies = Movies::Fetcher.new.call(Movie.includes(:genre).decorate)
  end

  def show
    @movie = Movies::Fetcher.new.call([@movie]).first.decorate
  end

  def send_info
    MovieInfoMailer.send_info(current_user, @movie).deliver_later
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    ExportMoviesJob.perform_later(current_user)
    redirect_to root_path, notice: "Movies exported"
  end

  protected

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
