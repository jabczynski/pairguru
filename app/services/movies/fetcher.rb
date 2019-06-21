module Movies
  class Fetcher
    API_URL = "https://pairguru-api.herokuapp.com".freeze
    MOVIES_PATH = "api/v1/movies".freeze
    FETCHABLE_ATTRIBUTES = %i[plot rating poster].freeze

    def call(movies = Movie.all)
      movies.tap { |records| fetch_and_append_attributes(records) }
    end

    private

    def fetch_and_append_attributes(movies)
      movies.each do |movie|
        response = send_get_request(movie.title)&.body

        next if response.blank?
        append_attributes(movie, get_attributes(response))
      end
    end

    def get_attributes(response)
      response_hash = JSON.parse(response).deep_symbolize_keys
      response_hash.dig(:data, :attributes)&.slice(*FETCHABLE_ATTRIBUTES) || {}
    end

    def append_attributes(record, attributes)
      attributes.each { |attr_key, attr_value| record.public_send("#{attr_key}=", attr_value) }
    end

    def send_get_request(movie_title)
      uri = movie_uri(movie_title)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request Net::HTTP::Get.new(uri)
      end
    rescue StandardError
      # TODO: We want to do sth with it, right?
      nil
    end

    def movie_uri(movie_title)
      URI([API_URL, MOVIES_PATH, URI.encode(movie_title)].join("/"))
    end
  end
end
