module API
  module V2
    class MoviesController < ApplicationController
      DEFAULT_SERIALIZER = ::V2::MovieSerializer

      def index
        render json: Movie.includes(:genre).all, each_serializer: DEFAULT_SERIALIZER
      end

      def show
        render json: Movie.find(params[:id]), serializer: DEFAULT_SERIALIZER
      end
    end
  end
end
