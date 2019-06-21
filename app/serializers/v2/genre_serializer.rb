module V2
  class GenreSerializer < ActiveModel::Serializer
    attributes :id, :name, :movies_count

    def movies_count
      object.movies.count
    end
  end
end
