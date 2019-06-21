module Comments
  class Creator
    CONTENT_MAX_LENGTH = 255

    def initialize(author, movie_id)
      @author = author
      @movie_id = movie_id
    end

    def call(content)
      @comment = Comment.new(content: content.to_s, movie_id: movie.id, user_id: author.id)
      validate_uniqueness_movie_id!
      validate_content_presence!
      validate_content_length!

      @comment.save! if @comment.errors.blank?

      @comment
    end

    private

    attr_reader :author, :movie_id

    def validate_content_presence!
      return if @comment.content.present?
      @comment.errors.add(:content, :blank)
    end

    def validate_uniqueness_movie_id!
      return unless author_already_commented_movie?
      @comment.errors.add(:movie_id, "already commented")
    end

    def validate_content_length!
      return unless @comment.content.length > CONTENT_MAX_LENGTH
      @comment.errors.add(:content, :too_long, count: CONTENT_MAX_LENGTH)
    end

    def author_already_commented_movie?
      movie.comments.pluck(:user_id).include? author.id
    end

    def movie
      @movie ||= Movie.find(movie_id)
    end
  end
end
