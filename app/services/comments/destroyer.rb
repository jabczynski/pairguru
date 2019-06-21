module Comments
  class Destroyer
    def initialize(author, comment_id)
      @author = author
      @comment_id = comment_id
    end

    def call
      comment.destroy!
    end

    private

    attr_reader :author, :comment_id

    def comment
      @comment ||= author.comments.find(comment_id)
    end
  end
end
