module V2
  class MovieSerializer < ActiveModel::Serializer
    belongs_to :genre, serializer: GenreSerializer

    attributes :id, :title
  end
end
