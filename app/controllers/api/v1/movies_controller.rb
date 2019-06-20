module API
  module V1
    class MoviesController < ApplicationController
      DEFAULT_SERIALIZER = ::V1::MovieSerializer

      def index
        render json: Movie.all, each_serializer: DEFAULT_SERIALIZER
      end

      def show
        render json: Movie.find(params[:id]), serializer: DEFAULT_SERIALIZER
      end
    end
  end
end
