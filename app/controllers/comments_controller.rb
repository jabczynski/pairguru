class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comments::Creator.new(current_user, params[:movie_id]).call(comment_params[:content])

    if @comment.errors.present?
      redirect_to @comment.movie, flash: { error: parse_error_messages }
    else
      redirect_to @comment.movie
    end
  end

  def destroy
    @comment = Comments::Destroyer.new(current_user, params[:id]).call
    redirect_to @comment.movie
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def parse_error_messages
    @comment.errors.full_messages.join(". ")
  end
end
